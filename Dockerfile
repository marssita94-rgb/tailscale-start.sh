FROM node:18-alpine
# Sau: FROM python:3.11-slim
# Sau: FROM golang:1.21-alpine
# Sau: FROM ubuntu:22.04

# Setează directorul de lucru
#WORKDIR /app

# Copiază scriptul Tailscale
COPY tailscale-start.sh 
RUN chmod +x /tailscale-start.sh

# Expune portul (dacă e cazul)
EXPOSE 8080

# CMD-ul
CMD ["/app/tailscale-start.sh"]
