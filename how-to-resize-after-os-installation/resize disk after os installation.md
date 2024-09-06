See the current size of the logical volume before 
```
df -hT /dev/mapper/ubuntu--vg-ubuntu--lv
```

Run a test first
```
sudo lvresize -tvl +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
```

Resize the logical volume 
```
sudo lvresize -vl +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
```
    
Resize the filesystem 
```
sudo resize2fs -p /dev/mapper/ubuntu--vg-ubuntu--lv
```
 
 Check the size of the logical volume to see if everything went smooth 
 
 ```
df -hT /dev/mapper/ubuntu--vg-ubuntu--lv
```
