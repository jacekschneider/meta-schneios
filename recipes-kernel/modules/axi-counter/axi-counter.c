#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>

#include <linux/fs.h>

#include <linux/slab.h>
#include <linux/io.h>
#include <linux/interrupt.h>

#include <linux/of_address.h>
#include <linux/of_device.h>
#include <linux/of_platform.h>

#include <linux/ioctl.h>

#define SUCEESS 0
#define DEVICE_NAME = "/dev/axi-counter"

#define MAGIC_NUM 100
#define DEVICE_FILE_NAME "/dev/blink_Dev"
#define IOCTL_STOP_LED _IOR(MAGIC_NUM, 1, char *)
#define IOCTL_ON_LED _IOR(MAGIC_NUM, 0, char *)


#define COUNTER_CTRL_REGION 0x43C00000
static unsigned long *mmio;
static int major_num;
static int device_opened = 0;