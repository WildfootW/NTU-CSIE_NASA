# pfSense Lab
https://hackmd.io/p/SJujfk44E

----

## 防火牆組

* 顏子斌
* 陳泓為
* 楊則軒

----

## What's pfSense

* 防火牆
* NAT
* DHCP
* VPN
* ...

----

## Why pfSense

* FreeBSD
* web GUI !!!

---

# LAB

----

## GOAL

* Install pfSense
* vlan 99 with DHCP on
* 1 VM in vlan 99

----

## Links
* [ISOs (Alpine Linux + pfSense) @ linux1](http://linux1.csie.ntu.edu.tw:9000/)

---

## Install pfSense

----

## Create a new VM
在 VirtualBox 裡新增一個 VM

----

## Insert ISO to virtual CD drive
![](https://i.imgur.com/2do32MO.png)

----

## Add WAN Interface
介面卡1 預設應該就長這樣
![](https://i.imgur.com/CbwBk93.png)

----

## Add LAN Interface
在 介面卡2 增加 LAN
![](https://i.imgur.com/I55bMZP.png)

----

## Install
就開機之後一直按下一步就好了XD
重開後會又回到安裝界面，關掉並把iso退出再重開就可以了
![](https://i.imgur.com/62Q0Szp.png)

---

## Connect to pfSense

----

## Connect to pfSense
一般來說，應該要接一台電腦到 LAN 來設定 pfSense。這邊為了方便我們**暫時**打開 WAN 的設定權限從外面設定。


在 production 的機器上請絕對不要把設定界面對外開放。

----

## Unblock WAN traffic

選擇第 12 項的 PHP shell + pfSense tools

```
playback enableallowallwan
exit
```

----

## Unblock WAN traffic
![](https://i.imgur.com/8r6W7tI.png)

----

## VirtualBox NAT - Find pfSense WAN IP addr
![](https://i.imgur.com/dYCxw3B.png)

----

## VirtualBox NAT - Add port forwarding
設定值 -> 網路 -> 介面卡1 -> 連接埠轉送
![](https://i.imgur.com/RGdT4VA.png)

----

## Connect to web configurator
![](https://i.imgur.com/eyHIxR6.png)

----

## Connect to web configurator
預設帳號 admin 預設密碼 pfsense
![](https://i.imgur.com/ucUYZvP.png)

---

## Install client VMs

----

## Choice of Client OS
Alpine Linux 是一個極輕量化的 linux 系統。我們會用 alpine 來完成這次 lab 的實作。 

* [alpine guide](https://wiki.alpinelinux.org/wiki/Install_Alpine_on_VirtualBox)

----

## Connect to pfSense LAN
安裝好設定完成之後，就可以把網路改接到 pfSense 的 LAN 了。
![](https://i.imgur.com/13Kut0u.png)

----

## Get IP from pfSense DHCP

* Find network interface name: `ip addr`
    * For example, interface is `eth0`
* Renew DHCP:
    * Alpine: `udhcpc -i eth0`

成功的話網路應該要會通。

---

## VLAN configuration - pfSense

----

## Add VLAN
Interface -> Assignments -> VLANs -> Add
![](https://i.imgur.com/VyOUOIt.png)

----

## Add VLAN Interface
點 Add 新增 Interface。
![](https://i.imgur.com/ckzGqPJ.png)

----

## VLAN Interface - Static IP
Enable 勾起來 並選擇 Static IP。
![](https://i.imgur.com/xuMscIJ.png)

----

## VLAN Interface - Set IP and netmask
設定 IP，要注意 netmask 要小於 31 不然就沒有 subnet 了。
![](https://i.imgur.com/ZIfJAVH.png)

----

## Enable VLAN DHCP
![](https://i.imgur.com/pimEArB.png)

----

## Set VLAN DHCP range
![](https://i.imgur.com/tyfZcPP.png)

---

## VLAN configuration - client VM

----

## Install VLAN

alpine: `apk add vlan`

----

## Add vlan

在 `/etc/network/interfaces` 增加下面幾行：
```
auto eth0.99
iface eth0.99 inet dhcp
```
其中 99 是 vlan 的 tag，而 eth0 是連接到 LAN 的網卡的名稱。

----

## Restart network service

```
/etc/init.d/networking restart
```
Lab checkpoint: 成功後`ip addr`就能看到新加的 vlan 了。

---

## Homework

----

## Some Hints

* Firewall -> Rules
* Firewall -> Schedules

---

## Credits
參考自以前 鄧逸軒, 陳力 & 瀚瀚 的 slide
