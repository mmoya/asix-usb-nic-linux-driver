# Importing a new release

Download the release archive from https://www.asix.com.tw/en/product/USBEthernet/Super-Speed_USB_Ethernet/AX88179B

```
mv src src.bak
mkdir src
tar --strip-components=1 -C src -xj -f /path/to/ASIX_USB_NIC_Linux_Driver_Source_v{version}.tar.bz2`
chmod -x src/*.c src/*.h src/Makefile src/Readme
git add src
git commit -m 'Release {version}'
```
