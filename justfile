# ASIX product page the driver release archive is downloaded from.
product_page := "https://www.asix.com.tw/en/product/USBEthernet/Super-Speed_USB_Ethernet/AX88179B"

# Download the latest Linux driver release and import it
import:
  #!/usr/bin/env bash
  set -euo pipefail

  test -d src.bak && { echo "Remove src.bak before proceeding."; exit 1; }

  work=$(mktemp -d)
  trap 'rm -rf "$work"' EXIT

  # The archive URL is not stable, so scrape it from the product page.
  curl -fsSL "{{ product_page }}" -o "$work/page.html"
  url=$(python3 - "$work/page.html" <<-'PY'
  	import re
  	import sys

  	page = open(sys.argv[1], encoding="utf-8").read()
  	for item in page.split('<div class="table_item">')[1:]:
  	    link = re.search(r'data-href="([^"]+)"', item)
  	    if link and "Linux" in item:
  	        print(link.group(1))
  	        break
  	else:
  	    sys.exit("no Linux driver download link on the product page")
  PY
  )

  # The server sets Content-Disposition, which curl uses for the filename.
  curl -fsSLOJ --output-dir "$work" "$url"
  archive=$(find "$work" -maxdepth 1 -name '*.tar.bz2' -print -quit)
  version=$(basename "$archive" | sed -E 's/^.*_v//; s/\.tar\.bz2$//')

  # Archive entries may or may not carry a leading "./", so extract first
  # and then locate the single top-level directory.
  mkdir "$work/x"
  tar -C "$work/x" -xj -f "$archive"
  top=$(find "$work/x" -mindepth 1 -maxdepth 1 -type d -not -name . -print -quit)
  test -n "$top" || { echo "No top-level directory in $archive"; exit 1; }

  mv src src.bak
  mv "$top" src
  # Upstream marks every file executable; none of them are.
  find src -type f -exec chmod 644 {} +
  # Upstream ships CRLF line endings; normalize text files to LF.
  { grep -rIlZ $'\r' src || true; } | xargs -0r sed -i 's/\r$//'
  git add src
  git commit -m "Release $version"
