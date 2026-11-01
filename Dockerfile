FROM node:18-alpine

# Instalează Tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Sau alternativ, cu curl direct:
# RUN curl -o /usr/bin/tailscale -LO https://pkgs.tailscale.com/stable/tailscale_1.66.2_amd64.tgz
# RUN tar -xzf tailscale_1.66.2_amd64.tgz tailscale && rm tailscale_1.66.2_amd64.tgz

WORKDIR /app

COPY tailscale-start.sh /app/tailscale-start.sh
RUN chmod +x /app/tailscale-start.sh

EXPOSE 8080

CMD ["/app/tailscale-start.sh"]
