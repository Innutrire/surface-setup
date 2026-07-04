# INNUTRIRE Surface Pro 7 Deployment Script

## Overview

This PowerShell deployment script automates the post-installation configuration of a Windows 10 device for the **INNUTRIRE** kiosk environment. It performs system configuration, account setup, networking, security hardening, application deployment, and shell replacement to minimize manual setup time and ensure consistent deployments.

---

## Features

The deployment script includes the following automated tasks:

### System Initialization

* Administrator privilege checking
* Comprehensive error handling
* Detailed logging (`C:\app\deployment.log`)
* Summary report generation
* Automatic reboot prompt upon completion

### User Account Configuration

* Create administrator account
* Restrict **innutrire** user account permissions
* Configure automatic login

### Windows Configuration

* Disable Edge Swipe
* Disable Windows Notifications
* Disable Lock Screen
* Disable Windows Tips
* Disable Microsoft Consumer Experience
* Disable Sleep mode
* Disable Display Timeout
* Disable Hibernate
* Set High Performance power plan
* Configure Rotation Lock registry settings

### Networking

* Install OpenSSH Server
* Configure SSH service
* Configure Windows Firewall
* Configure Static IP address (user configurable)

### Application Deployment

* Create `C:\app`
* Download the latest INNUTRIRE executable
* Configure Windows Shell Replacement

---

## Logging

All deployment activities, warnings, and errors are recorded in:

```text
C:\app\deployment.log
```

This log should be reviewed if any deployment issues occur.

---

## Requirements

* Windows 10 Pro
* PowerShell (Run as Administrator)
* Internet connection (required to download the INNUTRIRE executable)
* Administrator privileges

---

## Usage

Run the deployment script with Administrator privileges.

```powershell
.\deploy.ps1
```

The script will automatically perform all supported configuration steps and provide a deployment summary when finished.

---

## Configuration

Before running the script, configure any required deployment variables such as:

* Static IP address
* Subnet mask
* Default gateway
* DNS server
* Administrator account credentials
* INNUTRIRE executable download URL

---

## Documentation

For the complete deployment procedure, setup instructions, prerequisites, and manual steps, please refer to the official deployment guide:

**Surface Pro 7 Tablet Setup Guide**

https://app.notion.com/p/Surface-Pro-7-Tablet-Setup-Guide-a43cf07560158212842301ec819b15bb

This guide should be considered the primary reference for the complete deployment workflow.
