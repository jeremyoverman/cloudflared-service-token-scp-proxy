# cloudflared-service-token-scp-proxy

> [!NOTE]  
> This was forked from [Genesys225/cloudflared-service-token-ssh-proxy](https://github.com/Genesys225/cloudflared-service-token-ssh-proxy) and altered to copy files using SCP rather than running shell commands on the remote host through Cloudflare Tunnels.

## Encode Keys

To correctly encode your keys, use:

```bash
# PRIVATE_KEY
echo -n "$(cat ~/.ssh/id_rsa)" | base64 -w 0

# PUBLIC_KEY
echo -n "$(cat ~/.ssh/id_rsa.pub)" | base64 -w 0
```

then copy the results to your secret/var.

<!--doc_begin-->
### Inputs
|Input|Description|Default|Required|
|-----|-----------|-------|:------:|
|`CLIENT_ID`|Cloudflare access tunnel, service token id|`default`|yes|
|`CLIENT_SECRET`|Cloudflare access tunnel, service token secret|`default`|yes|
|`PUBLIC_KEY`|Asymmetric ssh keys for the intended client|`default`|yes|
|`PRIVATE_KEY`|Asymmetric ssh keys for the intended client|`default`|yes|
|`HOST`|Cloudflare access tunnel, associated application domain|`0.0.0.0`|yes|
|`USER`|Remote target username|`root`|yes|
|`PORT`|Ssh port|`22`|no|
|`KEY_TYPE`|SSH key type, like id_rsa or id_ed25519|`id_rsa`|no|
|`FILES`|List of files to copy|``|yes|
### Outputs
None
<!--doc_end-->

## Usage

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
