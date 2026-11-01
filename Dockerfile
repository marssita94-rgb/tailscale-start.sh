FROM tailscale/tailscale:latest

WORKDIR /render

COPY tailscale-start.sh /render/tailscale-start.sh
RUN chmod +x /render/tailscale-start.sh

CMD ["/render/tailscale-start.sh"]
