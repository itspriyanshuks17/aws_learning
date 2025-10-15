# 🧩 Difference Between Versioning and Snapshots in AWS

Both **Versioning** and **Snapshots** are mechanisms to protect and recover data in AWS — but they apply to different storage services and serve different purposes.

---

## 🧠 Concept Overview

| Feature | **Versioning** | **Snapshots** |
|----------|----------------|----------------|
| **Applicable Service** | Amazon S3 | Amazon EBS, RDS, EC2 |
| **Purpose** | Maintains multiple versions of an object within the same bucket | Creates a point-in-time backup of a volume or instance |
| **Type of Storage** | Object-based | Block-level |
| **Data Location** | Same S3 bucket | Snapshots are stored in Amazon S3 (managed automatically) |
| **Trigger** | Automatic upon overwrite/delete (if versioning enabled) | Manual or scheduled action |
| **Restoration** | Retrieve any version of the object | Create a new volume or restore from snapshot |
| **Granularity** | Per object | Per volume or database |
| **Storage Cost** | Each version consumes storage | Each snapshot stores changed data (incremental) |
| **Deletion Behavior** | Older versions remain until explicitly deleted | Snapshots persist until manually deleted |
| **Use Case** | Protecting against accidental overwrites/deletes in S3 | Backup, recovery, and cloning of EBS volumes or RDS databases |

---

## 🔍 Example Scenarios

### 🪣 S3 Versioning
- You upload a file `data.txt` to S3.  
- Later, you upload another `data.txt` (same key).  
- With **Versioning enabled**, both versions are stored:
  - `VersionID-1`: Original
  - `VersionID-2`: Updated file  
- You can **restore** the old version anytime.

```bash
aws s3api put-bucket-versioning \
  --bucket my-bucket \
  --versioning-configuration Status=Enabled
````

🟢 **Use Case:** Protect against accidental deletion or overwriting of files in S3.

---

### 💽 EBS Snapshots

* You have an **EBS volume** attached to your EC2 instance.
* Taking a **snapshot** captures the **state of that volume at that moment**.
* You can later use the snapshot to:

  * Restore data after failure.
  * Create a **new volume** in the same or another region.

```bash
aws ec2 create-snapshot --volume-id vol-0123456789abcdef --description "My backup snapshot"
```

🟢 **Use Case:** Backup and recovery of entire volumes or databases.

---

## 🧭 Visual Comparison

```
                 +---------------------------+
                 |       AWS Versioning      |
                 |---------------------------|
                 | Service: S3               |
                 | Level: Object-based       |
                 | Goal: Protect file changes|
                 | Action: Keep multiple     |
                 |         object versions   |
                 +---------------------------+

                 vs

                 +---------------------------+
                 |        AWS Snapshot       |
                 |---------------------------|
                 | Service: EBS, RDS, EC2    |
                 | Level: Block-based        |
                 | Goal: Backup volume state |
                 | Action: Point-in-time copy|
                 +---------------------------+
```

---

## 🧾 Quick Summary Table

| Criteria             | **Versioning (S3)**                    | **Snapshots (EBS/RDS)**                      |
| -------------------- | -------------------------------------- | -------------------------------------------- |
| **Used In**          | S3 (object storage)                    | EBS, RDS, EC2 (block storage)                |
| **Purpose**          | Maintain multiple object versions      | Backup/restore entire storage volumes        |
| **Automatic?**       | Enabled manually, then automatic       | Manual or automated (via lifecycle policies) |
| **Recovery Scope**   | Individual files                       | Entire storage device                        |
| **Storage Location** | Within same S3 bucket                  | Stored in S3 by AWS                          |
| **Cost Behavior**    | Increases with number of versions      | Incremental — stores only changed blocks     |
| **Best For**         | Accidental delete/overwrite protection | Disaster recovery, backups, cloning          |
| **Access Method**    | Retrieve specific version ID           | Create volume from snapshot                  |

---

✅ **In short:**

* **Versioning → Protects objects in S3.**
  Useful for file version control and accidental deletion recovery.
* **Snapshots → Back up entire block volumes (EBS, RDS).**
  Useful for disaster recovery, cloning, and restoring data quickly.
