# SharePoint Document Viewer

Upgrading from Previous Versions
================================

Prizm Content Connect for SharePoint 2013 v2.0 is a completely new architecture, based on capabilities introduced in SharePoint 2013. To remove a previous installation of PCC for SharePoint prior to installing the new version, do the following:

1.  Remove all references to "Prizm Preview Field".
    1.  For a document library, select **Library Settings** on the **Library** tab.
    2.  Select the **preview** column and then select **Delete**.
    3.  Repeat for all document libraries.

2.  Deactivate DRM feature.
    1.  In **Central Administration**, select **Manage web applications**.
    2.  Select the web application, e.g., "SharePoint - 80", and select **Manage Features**.
    3.  **Deactivate** the "Prizm Digital Rights Management" feature.

3.  Remove old solution.
    1.  Select **System Settings** \> **Manage farm solutions**.
    2.  Select **accusoft.pcc.sharepoint.wsp** and then select **Retract Solution**.
    3.  Once solution is no longer deployed, select it again and select **Remove Solution**.

Please contact Accusoft's Sales Department using <sales@accusoft.com> for assistance with upgrading.

Dependencies & Requirements
===========================

Prizm Content Connect for SharePoint 2013 has the following dependencies and requirements:

Server Dependencies
-------------------

-   SharePoint 2013 Server Standard or Enterprise Edition
-   Accusoft Prizm Content Connect (PCC) 10.x or Accusoft Cloud Services (ACS) Viewer
    -   [Getting Started with PCC](http://help.accusoft.com/PCC/v10.2/HTML/webframe.html#Getting%20Started%20with%20PCC.html)
    -   [Getting Started with ACS](http://help.accusoft.com/SAAS/pcc-for-acs/webframe.html#Getting%20Started.html)
-   (Optional) Microsoft Office Web Apps

Supported Operating Systems
---------------------------

-   Windows Server 2012
-   Windows Server 2012 R2

System Requirements
-------------------

-   Minimum 4GB RAM (in addition to memory requirements of the system installed on)
-   250MB of free disk space for product installation and logging
-   Internet Information Services (IIS)
-   Microsoft .NET Framework 4.5
-   Service Account - Administrator type (for PCC-WOPI web application), for example "WOPISVC"; PCC-WOPI application pool is configured to run as this account. This account requires permission to read and write to SharePoint lists.
-   Add "::1 prizm" to Windows hosts file

Required Permissions
--------------------

Users who install, configure, and manage the PCC for SharePoint product will need different permissions to perform various actions.

Installation of PCC for SharePoint using PowerShell requires the following:

-   User is a farm administrator
-   User is an administrator on the local machine

Setting up PCC WOPI Client
==========================

PCC WOPI Client is an IIS web application. There are two prerequisites needed for installation:

-   Host Name

    The web application is installed and addressed by a unique host name. This is typically a DNS host name associated with the IP address of the server hosting PCC WOPI Client, e.g., pccsp.contoso.com. For evaluation purposes, a host name can be added to your Windows hosts file. Open C:\\Windows\\System32\\Drivers\\etc\\hosts and add "127.0.0.1 pccsp", optionally replacing the IP address or host name with your own.

-   Service Account

    The web application is run as this specific user identity. This account requires Full Control to the physical path C:\\ProgramData, which is where the application is installed. In addition, this account requires Full Control to read and write to SharePoint lists, and therefore must be added to the web application’s "User Policy".

Once you have met the prerequisites above in addition to the Dependencies & Requirements, complete the steps below:

1. Install the PCC WOPI Client
------------------------------

**Note:** If you have already installed **PccWopiClient-2.0.msi**, you must uninstall it before re-installing it.

1.  Copy **PccWopiClient-2.0.msi** to PCC WOPI Client server
2.  Run **PccWopiClient-2.0.msi**
3.  Enter IIS host name and service account for the PCC-WOPI IIS site

The install adds an entry to **Programs and Features** with the current version and build number.

2. Modify pcc.config
--------------------

In the **pcc.config** file (**c:\\programdata\\accusoft\\prizm\\PCC-WOPI\\viewer-webtier\\pcc.config)**, you configure the following:

-   Whether you're integrating with Accusoft Cloud Services SaaS viewer, or with the on-premise Prizm Content Connect viewer
-   Whether you're integrating with Office Web Apps
-   Whether you're deploying over https
-   Which file types you want to view with the ACS or PCC viewer

### ACS Viewer or PCC Viewer

-   **ACS:**

    By default, PCC for SharePoint is configured to use the ACS viewer. If you want to use the ACS viewer, you just need to insert the ACS API key that you obtained at <https://www.accusoft.com/products/accusoft-cloud-services/portal/> in the **ApiKey** element.

-   **PCC:**

    If you're connecting to on-premise PCC server instead (installed on a different machine), modify the following:

    1.  Replace localhost with PCC host name
    2.  If PCC server is running in multi-server mode: Change **18681** to **18682** (default port for multi-server)

### Integrating with Office Web Apps

If you're integrating with Office Web Apps, specify the following:

1.  **owas-host-name** (to support **/hosting/discovery**)
2.  **owas account-name** and **password** with read access to **C:\\ProgramData\\Microsoft\\OfficeWebApps\\Data\\FarmState\\proofKey.txt**

### Deploying over https

Change **wopi-net-zone** to **internal-https** if deploying over https.

### File Types to View and Preview with ACS or PCC Viewer

-   Add or remove/comment **\<extension\>** elements to customize the file types to be viewed/previewed with ACS or PCC viewer.
-   If an extension is to be viewed, but not previewed, add attribute **interactive-preview="false"** to **\<extension\>** element.

**Note:** Any time you make changes to **pcc.config**, you need to then update the WOPI bindings by running **Update-PCCWOPIBindings.ps1** (see Setting up PCC for SharePoint for instructions).

Note the following pages served by the PCC-WOPI site:

-   Status page: **\<pcc-wopi-host-name\>**
-   Discovery page: **\<pcc-wopi-host-name\>/hosting/discovery**

**Troubleshooting Tip:** In case of error, refer to log files in folder: **C:\\ProgramData\\Accusoft\\Prizm\\PCC-WOPI\\Logs**

Setting up PCC for SharePoint
=============================

If you haven't already done so, create or designate an existing SharePoint Service Account, Administrator type, to use for PCC-WOPI web application, for example "WOPISVC". PCC-WOPI application pool is configured to run as this account. This account requires permission to read and write to SharePoint lists.

In **Central Administration \> Manage web applications**, select your web application (e.g., **SharePoint - 80**) and select **User Policy**. If the service account is not in the list with **Full Control**, do the following:

1.  Select **Add Users**
2.  Leave **Zones = (All zones)** and select **Next**
3.  Add service account name, grant **Full Control** and select **Finish**

**Note:** Installation of PCC for SharePoint using PowerShell requires that the User is a farm administrator, and is an administrator on the local machine.

To add custom viewer permissions and interactive-preview support for all supported file types:
----------------------------------------------------------------------------------------------

1.  In Windows Explorer, right-click **Install-PCCSPSolution.ps1** and select **Run with PowerShell**
2.  Enter the site collection URL (e.g., http://sharepoint)
3.  The solution is deployed, and the site collection feature "Accusoft Prizm Content Connect for SharePoint" is Activated

**Notes:**

-   If the solution was previously installed and removed while this feature was Active, in order to re-add custom permissions, you will need to go to Site Settings \> Site Collection Features, and Deactivate this feature, and then select Activate.
-   The SharePoint solution must be removed before the script can be run again. See Removing the PCC for SharePoint Solution below.

To update SharePoint WOPI bindings to PCC WOPI Client
-----------------------------------------------------

1.  In Windows Explorer, right-click **Update-PCCWOPIBinding.ps** and select **Run with PowerShell**

    **Note:** If connecting over https, first modify script to remove **-AllowHTTP**

    **Troubleshooting Tip:** If selecting PDF document link using Google Chrome does not open in PCC viewer:

    1.  Navigate to **Library Settings \> Advanced settings**
    2.  Verify **Opening Documents in the Browser** is not set to **Open in the client application**. If set to **Open in the client application**, then the **default-action** for PDF documents in Chrome will be to display in the Chrome viewer

Removing the PCC for SharePoint Solution
========================================

Using the SharePoint Interface
------------------------------

1.  Navigate to **Central Administration \> System Settings \> Manage farm solutions** (under Farm Management)
2.  Select **accusoft.pcc.wsp**
3.  Select **Retract Solution** \> click **OK**
4.  Refresh page.
5.  When Status = **Not Deployed**, select **accusoft.pcc.wsp**
6.  Select **Remove Solution** \> click **OK**

**Troubleshooting Tip:** If SharePoint indicates that you don’t have permission to remove the solution, turn off UAC via registry by changing the DWORD **EnableLUA** from **1** to **0** in **HKEY\_LOCAL\_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\policies\\system**. You will get a notification that a reboot is required. After the reboot, UAC is disabled.

Using PowerShell
----------------

**Note:** Installation or removal of PCC for SharePoint using PowerShell requires that the User is a farm administrator, and is an administrator on the local machine.

     $siteurl = <set site name here>
     disable-spfeature accusoft.pcc -url $siteurl
     uninstall-spsolution accusoft.pcc.wsp -webapplication $siteurl
     remove-spsolution accusoft.pcc.wsp

Support
=======

Learn more about [Prizm Content Connect for SharePoint here](https://www.accusoft.com/products/prizm-content-connect-sharepoint/overview/).

If you have questions, please visit our online [help center](https://accusofthelp.zendesk.com/hc/en-us).
