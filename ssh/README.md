# Yubikey PIV for SSH through PKCS

https://developers.yubico.com/PIV/Guides/SSH_with_PIV_and_PKCS11.html

```sh
pacman -S yubico-piv-tool
pacman -S pcsc-tools

# Start and enable the service
sudo systemctl enable --now pcscd

# !! NOTE: default pin is 123456 and can be changed by running:
yubico-piv-tool -a change-pin

# Verify
pcsc_scan

# Generate SSH key
ssh-keygen -t ecdsa -b 256 -f id_shared_yubikey -C home-ops
ssh-keygen -p -m PEM -f id_shared_yubikey

# Extract public key
openssl ec -in id_shared_yubikey -pubout -out public.pem

# Create self-signed certificate
yubico-piv-tool -a verify-pin -a selfsign-certificate -s 9a -S "/CN=SSH key/" -i public.pem -o cert.pem

### RUN FOR EACH KEY ###
# Import certificate
yubico-piv-tool -a import-certificate -s 9a -i cert.pem

# Import key
yubico-piv-tool -s 9a -a import-key -i id_shared_yubikey
########################

# Verify key and output public key
ssh-keygen -D /usr/lib/libykcs11.so -e | grep ecdsa-sha2-nistp256

```
