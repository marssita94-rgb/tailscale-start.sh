FROM tailscale/tailscale:latest

WORKDIR /app

COPY tailscale-start.sh /app/tailscale-start.sh
RUN chmod +x /app/tailscale-start.sh

CMD ["/app/tailscale-start.sh"]
