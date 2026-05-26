#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kdev_t.h>
#include <linux/fs.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/uaccess.h>
#include <linux/interrupt.h>
#include <linux/gpio.h>
#include <linux/delay.h>
#include <linux/err.h>
#include <linux/jiffies.h>
#include <linux/gpio/consumer.h>

#define GPIO_21_IN  (21)

unsigned int GPIO_irqNumber;
extern unsigned long volatile jiffies;
unsigned long old_jiffie = 0;

dev_t dev=0;

static struct device* device_trigger; 
static struct class *dev_class;
static struct cdev gpioint_cdev;
static struct gpio_desc* gpio_trigger;

static int __init gpioint_driver_init(void);
static void __exit gpioint_driver_exit(void);

static int gpioint_open(struct inode *inode, struct file *file);
static int gpioint_release(struct inode *inode, struct file *file);
static ssize_t gpioint_read(struct file *filp, char __user *buf, size_t len, loff_t *off);
static ssize_t gpioint_write(struct file *filp, const char __user *buf, size_t len, loff_t *off);
static struct file_operations fops =
{
    .owner = THIS_MODULE,
    .read = gpioint_read,
    .write = gpioint_write,
    .open = gpioint_open,
    .release = gpioint_release,
};

static int gpioint_open(struct inode *inode, struct file *file)
{
    dev_dbg(device_trigger, "Device file openend...");
    return 0;
}

static int gpioint_release(struct inode *inode, struct file *file)
{
    dev_dbg(device_trigger, "Device file closed...");
    return 0;
}

static ssize_t gpioint_read(struct file *filp, char __user *buf, size_t len, loff_t *off)
{
    char output[64] = "gpioint alive...";
    len = strlen(output);
    if (copy_to_user(buf, output, len) > 0)
    {
        dev_dbg(device_trigger, "ERROR: not all bytes have been copied to user...");
    }

    dev_dbg(device_trigger, "Device read called...\n");
    return 0;
}

static ssize_t gpioint_write(struct file *filp, const char __user *buf, size_t len, loff_t *off)
{
    uint8_t input[1024];
    if(copy_from_user(input, buf, len) > 0)
    {
        dev_err(device_trigger, "ERROR: not all bytes have been copied from user...\n");
    }

    dev_dbg(device_trigger, "Device write called with %s...\n", input);
    return len;
}

static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
{
    unsigned long diff = jiffies - old_jiffie;
    if (diff < 20)
    {
        return IRQ_HANDLED;
    }
    old_jiffie = jiffies;
    dev_dbg(device_trigger, "Interrupt triggered...\n");
    return IRQ_HANDLED;
}

static int __init gpioint_driver_init(void)
{
    /*Dynamically allocate major number*/
    if((alloc_chrdev_region(&dev, 0, 1, "gpioint_dev")) < 0)
    {
        goto r_unreg;
    }

    /*Create char. device*/
    cdev_init(&gpioint_cdev, &fops);

    /*Add char. device to the system*/
    if((cdev_add(&gpioint_cdev, dev, 1)) < 0)
    {
        goto r_del;
    }

    /*Create device class*/
    if(IS_ERR(dev_class = class_create("gpioint_class")))
    {
        goto r_class;
    }

    /*Create device*/
    device_trigger = device_create(dev_class, NULL, dev, NULL, "gpioint_device");
    if(IS_ERR(device_trigger))
    {
        dev_err(device_trigger, "Cannout create the device...\n");
        goto r_device;
    }

    //Input GPIO

    /*Request gpio*/
    gpio_trigger = gpiod_get(device_trigger, "trigger", GPIOD_IN);
    if(IS_ERR(gpio_trigger))
    {
        dev_err(device_trigger, "ERROR: GPIO get...\n");
        goto r_gpio;
    }

    GPIO_irqNumber = gpiod_to_irq(gpio_trigger);
    dev_dbg(device_trigger, "GPIO irq number is %d...\n", GPIO_irqNumber);

    if(request_irq(GPIO_irqNumber, (void*)gpio_irq_handler, IRQF_TRIGGER_RISING, "gpioint_device", NULL))
    {
        dev_err(device_trigger, "Error: failed to register the interrupt%d...\n", GPIO_irqNumber);
        goto r_gpio;
    }

    dev_dbg(device_trigger, "gpioint driver inserted successfully...\n");
    return 0;
r_gpio:
    gpio_free(GPIO_21_IN);
r_device:
    device_destroy(dev_class, dev);
r_class:
    class_destroy(dev_class);
r_del:
    cdev_del(&gpioint_cdev);
r_unreg:
    unregister_chrdev_region(dev, 1);
    return -1;
}

static void __exit gpioint_driver_exit(void)
{
    free_irq(GPIO_irqNumber, NULL);
    gpio_free(GPIO_21_IN);
    device_destroy(dev_class, dev);
    class_destroy(dev_class);
    cdev_del(&gpioint_cdev);
    unregister_chrdev_region(dev, 1);
    dev_dbg(device_trigger, "gpioint driver removed successfully...\n");
}

module_init(gpioint_driver_init);
module_exit(gpioint_driver_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Jacek Schneider <schneiderautomatyka@gmail.com>");
MODULE_DESCRIPTION("Basic kernel module - gpio interrupt");
MODULE_VERSION("1.0.0");