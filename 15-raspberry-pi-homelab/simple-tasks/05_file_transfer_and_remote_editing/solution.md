# Solution - File Transfer And Remote Editing

This solution covers the basic ways to move files and open Raspberry Pi directly in VS Code.

## 1. Copy One File To Raspberry Pi

```bash
scp ./local-file.txt pi5:/tmp/
```

## 2. Copy One File Back To Mac

```bash
scp pi5:/etc/hostname ./hostname-from-pi.txt
```

## 3. Sync A Folder To Raspberry Pi

```bash
rsync -avz ./my-project/ pi5:/srv/rs-data-platform/runtime/my-project/
```

## 4. Download Logs From Raspberry Pi

```bash
rsync -avz pi5:/srv/rs-data-platform/logs/ ./logs-from-pi/
```

## 5. Verify Files On Raspberry Pi

```bash
ssh pi5 'ls -lah /srv/rs-data-platform/runtime'
```

## 6. Open Raspberry Pi In VS Code

Use VS Code command palette:

1. run `Remote-SSH: Connect to Host...`
2. choose `pi5`
3. open `/srv/rs-data-platform`

## 7. Definition Of Done Check

This task is complete if:

- `scp` works in both directions
- `rsync` works for a folder
- you can verify files remotely with `ssh pi5`
- VS Code Remote SSH opens the Raspberry Pi host