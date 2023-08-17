# Starting CRI-O

Running make install will download CRI-O into the folder

```bash
/usr/local/bin/crio
```

You can run it manually there, or you can set up a systemd unit file with:

```bash
sudo make install.systemd
```

And let systemd take care of running CRI-O:

```bash
sudo systemctl daemon-reload
sudo systemctl enable crio
sudo systemctl start crio
```

## Reference

<https://github.com/cri-o/cri-o/blob/main/install.md#starting-cri-o>
