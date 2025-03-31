# Importing a new release

Download the release archive from https://www.asix.com.tw/en/product/USBEthernet/Super-Speed_USB_Ethernet/AX88179B

```
tar --strip-components=1 -xj -f /path/to/ASIX_USB_NIC_Linux_Driver_Source_v{version}.tar.bz2`
chmod -x *.c *.h Makefile Readme
git add Makefile Readme *.c *.h
git commit -m 'Release {version}'
```
