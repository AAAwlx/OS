# 配置grub与uefi启动

## 创建分区

```sh
# 创建 GPT 分区表
sudo parted /dev/loop0 mklabel gpt

# 创建大小为 512MB 的 EFI 分区
sudo parted /dev/loop0 mkpart primary fat32 1MB 512MB

# 设置分区标志为启动和 ESP
sudo parted /dev/loop0 set 1 boot on
sudo parted /dev/loop0 set 1 esp on

# 创建剩余空间的文件系统分区
sudo parted /dev/loop0 mkpart primary ext2 512MB 100%
```

## 格式化分区

```sh
# 格式化 EFI 分区为 fat32
sudo mkfs.vfat -F 32 -n "EFI" /dev/loop0p1

# 格式化剩余分区为 ext4
sudo mkfs.ext2 /dev/loop0p2

```

## 挂载分区

```sh
# 创建挂载点
sudo mkdir -p /home/ylx/hdmount

# 创建 EFI 目录
sudo mkdir -p /home/ylx/hdmount/EFI

# 挂载 EFI 分区
sudo mount /dev/loop0p1 /home/ylx/hdmount/EFI

# 创建boot目录
sudo mkdir -p /home/ylx/hdmount/boot

# 挂载文件系统分区
sudo mount /dev/loop0p2 /home/ylx/hdmount/boot

```

## 安装 GRUB

```sh
 sudo grub-install --target=x86_64-efi --efi-directory=/home/ylx/hdmount/EFI --boot-directory=/home/ylx/hdmount/boot --removable /dev/loop0

```

## GRUB 配置文件

直接生成：

```sh

sudo grub-mkconfig -o /home/ylx/hdmount/boot/grub/grub.cfg

```

手动配置：

```sh
sudo touch /home/ylx/hdmount/boot/grub/grub.cfg
code /home/ylx/hdmount/boot/grub/grub.cfg
```

打开后写入你想要的配置选项
