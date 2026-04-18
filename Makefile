TARGET	= ax_usb_nic
KDIR	:= /lib/modules/$(shell uname -r)/build
PWD	= $(shell pwd)
RULE_FILE = 50-ax_usb_nic.rules
RULE_PATH = /etc/udev/rules.d/

BLACKLIST_FILE = ax_usb_nic_blacklist.conf
BLACKLIST_PATH = /etc/modprobe.d/

ENABLE_IOCTL_DEBUG = n
ENABLE_AUTODETACH_FUNC = n
ENABLE_MAC_PASS = n
ENABLE_INT_AGGRESSIVE = y
ENABLE_INT_POLLING = n
ENABLE_AUTOSUSPEND = n
ENABLE_TX_TASKLET = y
ENABLE_RX_TASKLET = n
ENABLE_QUEUE_PRIORITY = n
ENABLE_LPM = y
ENABLE_SUSPEND_LP = y

ENABLE_QAV = n
ENABLE_RX_PREEMPT = n
ENABLE_COE = n
ENABLE_LSO = n

ENABLE_PTP_FUNC = n
ENABLE_PTP_DEBUG = n
ENABLE_AX88279A_PTP = n
ENABLE_AX88279A_PTP_2P5G_FRC = n
ENABLE_NORMAL_PKT_PTP = n
ENABLE_NORMAL_PKT_PTP_DEBUG_NORMAL = n
ENABLE_NORMAL_PKT_PTP_DEBUG_PTP = n

ENABLE_PTP_250M_CLK = n
ENABLE_PTP_125M_CLK = n
ENABLE_PTP_UTP_CLK = n
ENABLE_PTP_GPIO_SLTB = n
ENABLE_PTP_DELAY = n

obj-m := $(TARGET).o
$(TARGET)-objs := ax_main.o ax88179_178a.o ax88179a_772d.o
EXTRA_CFLAGS = -fno-pie
TOOL_EXTRA_CFLAGS = -Werror

ifeq ($(ENABLE_IOCTL_DEBUG), y)
	EXTRA_CFLAGS += -DENABLE_IOCTL_DEBUG
	TOOL_EXTRA_CFLAGS += -DENABLE_IOCTL_DEBUG
endif

ifeq ($(ENABLE_AUTODETACH_FUNC), y)
	EXTRA_CFLAGS += -DENABLE_AUTODETACH_FUNC
endif

ifeq ($(ENABLE_MAC_PASS), y)
	EXTRA_CFLAGS += -DENABLE_MAC_PASS
endif

ifeq ($(ENABLE_INT_AGGRESSIVE), y)
	EXTRA_CFLAGS += -DENABLE_INT_AGGRESSIVE
endif

ifeq ($(ENABLE_INT_POLLING), y)
	EXTRA_CFLAGS += -DENABLE_INT_POLLING
endif

ifeq ($(ENABLE_AUTOSUSPEND), y)
	EXTRA_CFLAGS += -DENABLE_AUTOSUSPEND
endif

ifeq ($(ENABLE_TX_TASKLET), y)
	EXTRA_CFLAGS += -DENABLE_TX_TASKLET
endif

ifeq ($(ENABLE_RX_TASKLET), y)
	EXTRA_CFLAGS += -DENABLE_RX_TASKLET
endif

ifeq ($(ENABLE_QUEUE_PRIORITY), y)
	EXTRA_CFLAGS += -DENABLE_QUEUE_PRIORITY
endif

ifeq ($(ENABLE_LPM), y)
	EXTRA_CFLAGS += -DENABLE_LPM
endif

ifeq ($(ENABLE_SUSPEND_LP), y)
	EXTRA_CFLAGS += -DENABLE_SUSPEND_LP
endif

ifeq ($(ENABLE_QAV), y)
	EXTRA_CFLAGS += -DENABLE_QAV
endif

ifeq ($(ENABLE_RX_PREEMPT), y)
	EXTRA_CFLAGS += -DENABLE_RX_PREEMPT
endif

ifeq ($(ENABLE_COE), y)
	EXTRA_CFLAGS += -DENABLE_COE
endif

ifeq ($(ENABLE_LSO), y)
	EXTRA_CFLAGS += -DENABLE_LSO
endif

ifeq ($(ENABLE_PTP_FUNC), y)
	$(TARGET)-objs += ax_ptp.o
	EXTRA_CFLAGS += -DENABLE_PTP_FUNC
	ifeq ($(ENABLE_PTP_DEBUG), y)
		EXTRA_CFLAGS += -DENABLE_PTP_DEBUG
	endif
	ifeq ($(ENABLE_AX88279A_PTP), y)
		EXTRA_CFLAGS += -DENABLE_AX88279A_PTP
		ifeq ($(ENABLE_AX88279A_PTP_2P5G_FRC), y)
			EXTRA_CFLAGS += -DENABLE_AX88279A_PTP_2P5G_FRC
		endif
	endif
endif

ifeq ($(ENABLE_NORMAL_PKT_PTP), y)
	EXTRA_CFLAGS += -DENABLE_NORMAL_PKT_PTP
endif

ifeq ($(ENABLE_NORMAL_PKT_PTP_DEBUG_NORMAL), y)
	EXTRA_CFLAGS += -DENABLE_NORMAL_PKT_PTP_DEBUG_NORMAL
endif

ifeq ($(ENABLE_NORMAL_PKT_PTP_DEBUG_PTP), y)
	EXTRA_CFLAGS += -DENABLE_NORMAL_PKT_PTP_DEBUG_PTP
endif

ifeq ($(ENABLE_PTP_250M_CLK), y)
	EXTRA_CFLAGS += -DENABLE_PTP_250M_CLK
	TOOL_EXTRA_CFLAGS += -DENABLE_PTP_250M_CLK
endif

ifeq ($(ENABLE_PTP_125M_CLK), y)
	EXTRA_CFLAGS += -DENABLE_PTP_125M_CLK
	TOOL_EXTRA_CFLAGS += -DENABLE_PTP_125M_CLK
endif

ifeq ($(ENABLE_PTP_UTP_CLK), y)
	EXTRA_CFLAGS += -DENABLE_PTP_UTP_CLK
	TOOL_EXTRA_CFLAGS += -DENABLE_PTP_UTP_CLK
endif

ifeq ($(ENABLE_PTP_GPIO_SLTB), y)
	EXTRA_CFLAGS += -DENABLE_PTP_GPIO_SLTB
	TOOL_EXTRA_CFLAGS += -DENABLE_PTP_GPIO_SLTB
endif

ifeq ($(ENABLE_PTP_DELAY), y)
	EXTRA_CFLAGS += -DENABLE_PTP_DELAY
	TOOL_EXTRA_CFLAGS += -DENABLE_PTP_DELAY
endif


ifneq (,$(filter $(SUBLEVEL),14 15 16 17 18 19 20 21))
MDIR	= kernel/drivers/usb/net
else
MDIR	= kernel/drivers/net/usb
endif

ccflags-y += $(EXTRA_CFLAGS)

all:
	make -C $(KDIR) M=$(PWD) modules
	$(CC) $(TOOL_EXTRA_CFLAGS) ax88179_programmer.c -o ax88179_programmer
	$(CC) $(TOOL_EXTRA_CFLAGS) ax88179a_programmer.c -o ax88179b_179a_772e_772d_programmer
	$(CC) $(TOOL_EXTRA_CFLAGS) ax88279_programmer.c -o ax88279a_279_programmer
	$(CC) $(TOOL_EXTRA_CFLAGS) ax88179a_ieee.c -o ax88279_179ab_772e_ieee
	$(CC) $(TOOL_EXTRA_CFLAGS) axcmd.c -o axcmd

install:
	make -C $(KDIR) M=$(PWD) INSTALL_MOD_DIR=$(MDIR) modules_install
	depmod -a

install_all:
	make -C $(KDIR) M=$(PWD) INSTALL_MOD_DIR=$(MDIR) modules_install
	install --group=root --owner=root --mode=0644 $(RULE_FILE) $(RULE_PATH)
	install --group=root --owner=root --mode=0644 $(BLACKLIST_FILE) $(BLACKLIST_PATH)
	depmod -a

uninstall:
ifneq (,$(wildcard /lib/modules/$(shell uname -r)/$(MDIR)/$(TARGET).ko))
	rm -f /lib/modules/$(shell uname -r)/$(MDIR)/$(TARGET).ko
endif

ifneq (,$(wildcard $(RULE_PATH)$(RULE_FILE)))
	rm -f $(RULE_PATH)$(RULE_FILE)
endif

ifneq (,$(wildcard $(BLACKLIST_PATH)$(BLACKLIST_FILE)))
	rm -f $(BLACKLIST_PATH)$(BLACKLIST_FILE)
endif
	depmod -a

clean:
	make -C $(KDIR) M=$(PWD) clean
	rm -rf *_programmer *_ieee axcmd .tmp_versions

udev_install:
	install --group=root --owner=root --mode=0644 $(RULE_FILE) $(RULE_PATH)

blacklist_install:
	install --group=root --owner=root --mode=0644 $(BLACKLIST_FILE) $(BLACKLIST_PATH) 
