# Dockerfile for your-cli-name

FROM scratch

# Copy ca-certificates for HTTPS requests to your-cli-name controllers
COPY --from=alpine:latest@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Copy the pre-built binary from GoReleaser
COPY your-cli-name /your-cli-name

# Create a non-root user (using numeric ID for scratch image)
USER 65534:65534

# Set the entrypoint
ENTRYPOINT ["/your-cli-name"]

# Default command shows help
CMD ["--help"]
