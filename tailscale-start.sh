#!/bin/bash
set -euo pipefail

# Variabile
AUTH_KEY="${TAILSCALE_AUTH_KEY:-}"
TUN="${TUN:-false}"
EXIT_NODE="${ADVERTISE_EXIT_NODE:-true}"
SERVICES="${TAILSCALE_SERVICES:-}"

# Funcție de logare
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Verifică dacă Tailscale rulează deja
if pgrep -x tailscaled > /dev/null 2>&1 || pgrep -x tailscale > /dev/null 2>&1; then
    log "Tailscale este deja în execuție, verificare stare..."
    
    # Setează flag-ul exit node dacă nu e setat
    if [[ "$EXIT_NODE" == "true" ]]; then
        log "Asigurăm flag-ul exit node..."
        tailscale set --advertise-exit-node 2>/dev/null || true
    fi
    
    log "Tailscale este deja pornit."
    exit 0
fi

# Setează flag-ul exit node
if [[ "$EXIT_NODE" == "true" ]]; then
    log "Setează flag-ul exit node..."
    tailscale set --advertise-exit-node 2>/dev/null || true
fi

# Configurează tun device dacă e necesar
if [[ "$TUN" == "true" ]]; then
    log "Configurează tun device..."
    ip tuntap add name tailscale0 mode tun || true
    ip link set tailscale0 up
fi

# Porneste Tailscale
if [[ -n "$AUTH_KEY" ]]; then
    log "Porneste Tailscale cu auth key..."
    tailscale up --authkey="$AUTH_KEY" \
                 --advertise-exit-node \
                 --tun="$TUN" \
                 --hostname="${HOSTNAME:-}"
else
    log "Porneste Tailscale fara auth key (autentificare cu browser)..."
    tailscale up --advertise-exit-node \
                 --tun="$TUN" \
                 --hostname="${HOSTNAME:-}"
fi

# Afișează statusul
log "Status Tailscale:"
tailscale status

# Afișează IP-ul Tailscale
log "IP-ul Tailscale: $(tailscale ip -4)"

# Dacă sunt servicii configurate, le pornește
if [[ -n "$SERVICES" ]]; then
    log "Porneste serviciile: $SERVICES"
    for service in $SERVICES; do
        log "  → $service"
        # Aici poți adapta în funcție de ce rulăm
        if command -v $service &> /dev/null; then
            $service &
        fi
    done
fi

# Așteaptă și menține procesul (pentru a nu se închide containerul)
log "Tailscale rulează. Aștept..."
wait

