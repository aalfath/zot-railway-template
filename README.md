# Deploy and Host Zot on Railway

Zot is a vendor-neutral, OCI-native container image registry from the CNCF. It stores Docker and OCI images, Helm charts and other OCI artifacts, and works with `docker`, `podman`, `oras`, `helm` and Kubernetes. A single binary provides the registry, a web UI, search, deduplication and garbage collection.

## About Hosting Zot

This template deploys Zot v2.1.21 from a small public wrapper image that builds on the official binary, pinned by digest. On every start it generates the login file from environment variables, so the admin password is set at deploy time and rotating it is a redeploy. Images are stored on a Railway volume with deduplication and garbage collection on. Anonymous pulls are off by default; set `ZOT_ANONYMOUS_READ=true` to make images public. Push and pull go through the Railway domain over HTTPS. Plan storage for your images: the Hobby volume limit is 5 GB.

## Common Use Cases

- A private registry for CI-built images deployed to Railway or Kubernetes
- Hosting Helm charts and other OCI artifacts next to your images
- Mirroring base images your team depends on

## Dependencies for Zot Hosting

- `aalfath/zot-railway-template` (public wrapper around `ghcr.io/project-zot/zot-linux-amd64:v2.1.21`)
- A Railway volume at `/var/lib/registry` for image storage

### Deployment Dependencies

- [Zot documentation](https://zotregistry.dev/)
- [Zot v2.1.21 release](https://github.com/project-zot/zot/releases/tag/v2.1.21)
- [Wrapper repository](https://github.com/aalfath/zot-railway-template)
- [Railway volumes](https://docs.railway.com/reference/volumes)

### Implementation Details

| Service | Source | Networking | Storage |
| --- | --- | --- | --- |
| zot | `aalfath/zot-railway-template` | public domain on 5000 | volume at `/var/lib/registry` |

```bash
docker login <domain> -u admin
docker tag my-app:latest <domain>/my-app:1.0
docker push <domain>/my-app:1.0
```

| Variable | Default | Purpose |
| --- | --- | --- |
| `ZOT_ADMIN_USER` / `ZOT_ADMIN_PASSWORD` | `admin` / generated | Admin login |
| `ZOT_EXTRA_USERS` | unset | Extra users, `name:password` separated by spaces (read, push, delete) |
| `ZOT_ANONYMOUS_READ` | `false` | Allow anonymous pulls |

Notes:

- CVE scanning is not enabled; it downloads a large vulnerability database and needs more memory.
- Railway's proxy limits request size and duration; very large layers may need several attempts.

This is a community-maintained deployment package and does not imply affiliation with or endorsement by the Zot project or its maintainers.

## Why Deploy Zot on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Zot on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
