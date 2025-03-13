# cloudflared-service-token-scp-proxy

To correctly encode your keys, use:

```bash
# PRIVATE_KEY
echo -n "$(cat ~/.ssh/id_rsa)" | base64 -w 0

# PUBLIC_KEY
echo -n "$(cat ~/.ssh/id_rsa.pub)" | base64 -w 0
```

then copy the results to your secret/var.

Copy files or directories through cloudflared tunnel proxy:

```yml
example:
  - name: cloudflared-service-token-scp-proxy
      uses: jeremyoverman/cloudflared-service-token-scp-proxy@V1
      with:
        HOST: ipv4/ipv6 | host address
        USER: username
        PORT: 22
        CLIENT_ID: ${{ secrets.CLIENT_ID }}
        CLIENT_SECRET: ${{ secrets.CLIENT_SECRET }}
        PUBLIC_KEY: ${{ secrets.PUBLIC_KEY }}
        PRIVATE_KEY: ${{ secrets.PRIVATE_KEY }}
        KEY_TYPE: id_rsa
        FILES: |
          ./deploy/staging/docker-compose.yml:/docker/app/docker-compose.yml
          ./deploy/staging/seed:/docker/app/seed
```
