/*
 * procs_showall.c
 ******************************************
 * (c) Author: Mralians <angryredninja26@gmail.com>
 ******************************************
 * Brief Description:
 *
 */
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/sched.h>
#include <linux/cred.h>
#include <linux/fs.h>
#include <linux/slab.h>
#include <linux/uaccess.h>
#include <linux/kallsyms.h>
#include <linux/sched/signal.h>

#define pr_fmt(fmt) "%s:%s():%d: " fmt,KBUILD_MODNAME,__func__,__LINE__

MODULE_AUTHOR("mralians <angryredninja26@gmail.com>");
MODULE_LICENSE("GPL");
MODULE_VERSION("0.1");

static int procs_showall(void)
{
#define BUF_SIZE 128
	struct task_struct *p;
	char temp[BUF_SIZE];
	int num_procs_rd = 0;
	//char header[] = "CURRENT             | STACK-START           | PID   | UID   | EUID | NAME";
	//printk("%s\n", &header[0]);

	rcu_read_lock();
	for_each_process(p) {
		memset(temp, 0, BUF_SIZE);
		snprintf(temp, BUF_SIZE, "%20pK|%20pK|%8d|%8d|%7u|%7u| %s\n",
			 p ,p->stack, p->exit_state, p->pid,
			 __kuid_val(p->cred->uid), __kuid_val(p->cred->euid),
       p->comm);
		num_procs_rd++;
		printk("%s\n", temp);
		cond_resched();
	}
	rcu_read_unlock();
	return num_procs_rd;
}

static int __init procs_showall_init(void)
{
	pr_info("inserted\n");
	int num_procs = procs_showall();
  pr_info("num_procs: %d\n",num_procs);
	return 0;
}

static void __exit procs_showall_exit(void)
{
	pr_info("removed\n");
}

module_init(procs_showall_init);
module_exit(procs_showall_exit);
