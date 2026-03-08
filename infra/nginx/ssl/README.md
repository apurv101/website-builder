# SSL Certificates

Managed by certbot on the EC2 instance. **Not tracked in git.**

## Location on EC2

```
/etc/letsencrypt/live/zevza.com/fullchain.pem
/etc/letsencrypt/live/zevza.com/privkey.pem
```

## Auto-renewal

Certbot systemd timer handles renewal automatically:

```bash
sudo systemctl status certbot.timer
sudo certbot renew --dry-run   # test renewal
```

## Recovery (re-issue certs)

```bash
sudo certbot certonly --nginx -d "*.zevza.com" -d zevza.com
```
