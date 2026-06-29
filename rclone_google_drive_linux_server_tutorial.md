# Download Large Google Drive Folders to a Linux Server Using `rclone`

This guide shows how to download large datasets (e.g., Nanopore/GridION sequencing data) directly from Google Drive to a Linux server using **rclone**.

## 1. Install rclone

```bash
sudo apt update
sudo apt install rclone
```

Or:

```bash
curl https://rclone.org/install.sh | sudo bash
```

Verify:

```bash
rclone version
```

## 2. Configure Google Drive

```bash
rclone config
```

Choose:
- `n` → New remote
- Name: `google-drive-ipmon`
- Storage: `24` (Google Drive)
- `client_id`: press **Enter**
- `client_secret`: press **Enter**
- Scope: `2` (Read-only)
- `service_account_file`: press **Enter**
- Advanced config: `n`
- Browser auth:
  - `n` if using SSH
  - `y` if on a local desktop
- Shared Drive: `n`
- Save remote: `y`
- Quit: `q`

## 3. Verify

```bash
rclone lsd google-drive-ipmon:
```

## 4. Shared folder not showing?

If a folder is only shared by link:

1. Open the Google Drive link.
2. Click **Add shortcut to Drive**.
3. Add it anywhere in **My Drive**.

Then verify again:

```bash
rclone lsd google-drive-ipmon:
```

## 5. Browse

List folders:

```bash
rclone lsd "google-drive-ipmon:joao"
```

List files:

```bash
rclone ls "google-drive-ipmon:joao"
```

## 6. Download

```bash
mkdir -p ~/gridion_data

rclone copy \
    "google-drive-ipmon:joao" \
    ~/gridion_data \
    --progress \
    --transfers 8 \
    --checkers 16 \
    --fast-list
```

### Options

| Option | Purpose |
|--------|---------|
| `--progress` | Show progress |
| `--transfers 8` | Parallel downloads |
| `--checkers 16` | Parallel file checking |
| `--fast-list` | Faster listing for large folders |

## 7. Resume interrupted downloads

Simply rerun the same command:

```bash
rclone copy \
    "google-drive-ipmon:joao" \
    ~/gridion_data \
    --progress \
    --transfers 8 \
    --checkers 16 \
    --fast-list
```

Only missing files will be transferred.

## 8. Verify integrity

```bash
rclone check \
    "google-drive-ipmon:joao" \
    ~/gridion_data
```

## Useful commands

```bash
rclone lsd google-drive-ipmon:
rclone ls google-drive-ipmon:
rclone size "google-drive-ipmon:joao"
```

## Notes

- Ideal for large sequencing datasets (FASTQ, POD5, BAM).
- `rclone` resumes interrupted downloads automatically.
- Add shared folders as shortcuts to **My Drive** if they don't appear.
- Never share OAuth tokens. If exposed, revoke access and reconnect `rclone`.
