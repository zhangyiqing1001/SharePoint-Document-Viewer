Document Viewer for SharePoint Overview
=======================================

Our responsive HTML5 document viewer easily integrates into your SharePoint 2013 application allowing you to display all major file formats right within the browser — no downloading required. The SharePoint document viewer can be used with either our on-premise Prizm Content Connect document viewer platform or our hosted Accusoft Cloud Services SaaS document viewer solution.

The SharePoint document viewer provides a wide array of document viewing and management tools that include:

-   Advanced Search
    -   Full text search
    -   Case-sensitive search
    -   Match exact word or phrase
    -   Wildcard searches
-   Redactions
    -   Remove sensitive data securely from documents
    -   Auto redact keywords or phrases
-   E-Sign
    -   Electronic signature tools that allow you to digitally sign a document directly in the browser
    -   The signature is a vector-based and securely burned into the document like a redaction
-   Document Viewing Tools
    -   Zoom and Magnify
    -   Thumbnails
    -   Rotate pages or entire document
    -   Full screen viewing
    -   Mobile document viewing

The SharePoint document viewer supports Microsoft Office documents (Word, Excel, and PowerPoint), PDF, CAD EML, PNG, JPG, JPEG, GIF, TIF and all other major file formats.

Enhance your SharePoint document workflow by integrating our advanced search within documents such as customer contracts and purchase orders. Redact sensitive information from documents. Sign documents right in the web browser to streamline your workflow.

Upgrading from Previous Versions
================================

Prizm Content Connect for SharePoint 2013 v2.x is a completely new architecture, based on capabilities introduced in SharePoint 2013. If you are upgrading from a PCC for SharePoint version prior to v2.0, remove the previous installation of PCC for SharePoint prior to installing the new version, as follows:

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

**Note:** If you are upgrading from v2.0 to a later version of v2.x, please see the instructions in "Release Notes for v2.1" below.

Dependencies & Requirements
===========================

Prizm Content Connect for SharePoint 2013 has the following dependencies and requirements:

Server Dependencies
-------------------

-   SharePoint 2013 Server Standard or Enterprise Edition
-   Accusoft Prizm Content Connect (PCC) 10.x or Accusoft Cloud Services (ACS) Viewer
    -   [Getting Started with PCC](http://help.accusoft.com/PCC/v10.2/HTML/webframe.html#Getting%20Started%20with%20PCC.html)
    
        **Note:** PCC for SharePoint processes requests from the PCC for SharePoint web tier only; requests from other PCC web tiers will return an error. As such, we recommend that when you install PCC, that you deselect the option to install the client samples, as they will not work.
    -   [Getting Started with ACS](http://help.accusoft.com/SAAS/pcc-for-acs/webframe.html#Getting%20Started.html)
-   (Optional) Microsoft Office Web Apps
-   (Optional) SSL certificate

	**Note:** For help setting up your SSL certificates on IIS, please refer to the instructions from Microsoft at <https://technet.microsoft.com/en-us/library/cc732230(v=ws.10).aspx>

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

Required Permissions
--------------------

Users who install, configure, and manage the PCC for SharePoint product will need different permissions to perform various actions.

### Installing with PowerShell

Installation of PCC for SharePoint using PowerShell requires the following:

-   User is a farm administrator
-   User is an administrator on the local machine

### Removing System Account Limitations

If the upper right of the window shows that the current user is "System Account", it is because the current "Account operates as System".

SharePoint does not support Preview or View in Browser as the System Account. This applies to both Office Web Apps and PCC WOPI Client.

To remove this setting from an account:

1.  In Central Administration, go to Security > Specify web application user policy
2.  Select the account and "Edit Permissions of Selected Users"
3.  Uncheck "Account operates as System"

Setting up PCC WOPI Client
==========================

PCC WOPI Client is an IIS web application. There are two prerequisites needed for installation:

-   Host Name

    The web application is installed and addressed by a unique host name. This is typically a DNS host name associated with the IP address of the server hosting PCC WOPI Client, e.g., pccsp.contoso.com. For evaluation purposes, a host name can be added to your Windows hosts file. For example, in **C:\Windows\System32\Drivers\etc\hosts**, add **127.0.0.1 pccsp** for TCP/IPv4, or **::1 pccsp** for TCP/IPv6.

-   Service Account

    The web application is run as this specific user identity. This account requires Full Control to the physical path C:\\ProgramData, which is where the application is installed. In addition, this account requires Full Control to read and write to SharePoint lists, and therefore must be added to the web application’s "User Policy".

Once you have met the prerequisites above in addition to the Dependencies & Requirements, complete the steps below:

1. Install PCC WOPI Client
------------------------------

**Notes:** 

   -  Office Web Apps and PCC WOPI Client must be installed on the same port (80 or 443) (http or https).

To install the PCC WOPI Client:

1.  Copy **PccWopiClient.msi** to PCC WOPI Client server
2.  Run **PccWopiClient.msi**
3.  Select either HTTP or SSL protocol to install PCC WOPI Client. This will configure PCC WOPI Client to run on port 80 or 443 respectively.
4.  Enter IIS host name and service account for the PCC-WOPI IIS site

The install adds an entry to **Programs and Features** with the current version and build number.

2. Modify pcc.config
--------------------

In the **pcc.config** file (**c:\\programdata\\accusoft\\prizm\\PCC-WOPI\\viewer-webtier\\pcc.config)**, you configure the following:

-   Whether you're integrating with Accusoft Cloud Services, or with on-premise Prizm Content Connect 
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

1.  **owas-host-name** (to support **/hosting/discovery**) e.g., owas or owas.my-domain.com
2.  The PCC-WOPI application pool identity must be added as a local Administrator to the Office Web Apps server.

### Deploying over https

A SharePoint farm is configured to navigate the browser to a WOPI application over http or https. Therefore, Office Web Apps and PCC WOPI Client must be deployed on the same port (either port 80 or 443).

Change **wopi-net-zone** to **internal-https** if deploying over https.

### File Types to View and Preview with ACS or PCC Viewer

-   Add or remove/comment **\<extension\>** elements to customize the file types to be viewed/previewed with ACS or PCC viewer.
-   If an extension is to be viewed, but not previewed, add attribute **interactive-preview="false"** to **\<extension\>** element.

**Note:** Any time you make changes to **pcc.config**, you need to then update the WOPI bindings by running **Update-PCCWOPIBindings.ps1** (see "Setting up PCC for SharePoint" for instructions).

Note the following pages served by the PCC-WOPI site:

-   Status page: **\<pcc-wopi-host-name\>**
-   Discovery page: **\<pcc-wopi-host-name\>/hosting/discovery**

**Troubleshooting Tip:** In case of error, refer to log files in folder: **C:\\ProgramData\\Accusoft\\Prizm\\PCC-WOPI\\Logs**

Setting up PCC for SharePoint
=============================

If you haven't already done so, create or designate an existing SharePoint Service Account, Administrator type, to use for PCC-WOPI web application, for
example "WOPISVC". PCC-WOPI application pool is configured to run as this account. This account requires permission to read and write to SharePoint lists.

In **Central Administration \> Manage web applications**, select your web application (e.g., **SharePoint - 80**) and select **User Policy**. If the service account is not in the list with **Full Control**, do the following:

1.  Select **Add Users**
2.  Leave **Zones = (All zones)** and select **Next**
3.  Add service account name, grant **Full Control** and select **Finish**
4.  Verify that "Account operates as System" is NOT checked. Please refer to "Removing 'System Account' Limitations" under the "Dependencies & Requirements" section, above.
	
**Notes:** 

-  Installation of PCC for SharePoint using PowerShell requires that the User is a farm administrator, and is an administrator on the local machine.
-  If executing the installation script from within the SharePoint 2013 Management Shell, you must launch the shell using **Run as Administrator**.

To add custom viewer permissions and interactive-preview support for all supported file types:
----------------------------------------------------------------------------------------------

1.  In Windows Services, verify "SharePoint Administration" is started
2.  In Windows Explorer, right-click **Install-PCCSPSolution.ps1** and select **Run with PowerShell**
3.  Enter the site collection URL (e.g., http://sharepoint)
4.  The solution is deployed, and the site collection feature "Accusoft Prizm Content Connect for SharePoint" is Activated

**Note:** The SharePoint solution must be removed before the script can be run again. See "Removing the PCC for SharePoint Solution" below.

To update SharePoint WOPI bindings for PCC WOPI Client
-----------------------------------------------------

1.  In Windows Explorer, right-click **Update-PCCWOPIBinding.ps1** and select **Run with PowerShell**
2.  Enter the host name that was specified when installing PCC WOPI Client
3.  If PCC WOPI Client is installed using SSL, select [Y]es when prompted, otherwise, select [N]o 

    **Troubleshooting Tip:** If selecting PDF document link using Google Chrome does not open in PCC viewer:

    1.  Navigate to **Library Settings \> Advanced settings**
    2.  Verify **Opening Documents in the Browser** is not set to **Open in the client application**. If set to **Open in the client application**, then the **default-action** for PDF documents in Chrome will be to display in the Chrome viewer

Removing the PCC for SharePoint Solution
========================================

Using the SharePoint Interface
------------------------------

1.  In Windows Services, verify "SharePoint Administration" is started.
2.  For each site collection where the feature may be activated, navigate to **Site settings > Site collection features** and **Deactivate** the **Accusoft Prizm Content Connect for SharePoint** feature.
3.  Navigate to **Central Administration \> System Settings \> Manage farm solutions** (under Farm Management)
4.  Select **accusoft.pcc.wsp**
5.  Select **Retract Solution** \> click **OK**
6.  Refresh page.
7.  When Status = **Not Deployed**, select **accusoft.pcc.wsp**
8.  Select **Remove Solution** \> click **OK**

**Troubleshooting Tip:** If SharePoint indicates that you don’t have permission to remove the solution, turn off UAC via registry by changing the DWORD **EnableLUA** from **1** to **0** in **HKEY\_LOCAL\_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\policies\\system**. You will get a notification that a reboot is required. After the reboot, UAC is disabled.

Removing SharePoint WOPI bindings to PCC WOPI Client
----------------------------------------------------

1.  In Windows Explorer, right-click **Remove-PCCWOPIBinding.ps1** and select **Run with PowerShell**

Using PowerShell
----------------

**Note:** Installation or removal of PCC for SharePoint using PowerShell requires that the User is a farm administrator, and is an administrator on the local machine.

      disable-spfeature accusoft.pcc -url \$siteurl
      uninstall-spsolution accusoft.pcc.wsp -webapplication \$siteurl
      remove-spsolution accusoft.pcc.wsp
      get-spwopibinding -application pcc | remove-spwopibinding -confirm:$false

Release Notes for v2.1.1
======================

PCC for SharePoint v2.1.1 addresses the following issue:

Issues Resolved
---------------

- Viewer does not reflect the correct features for a user granted permissions via a user group nested within another user group, or potentially other Active Directory configuration scenarios. 

Release Notes for v2.1
======================

PCC for SharePoint v2.1 addresses the following issues and includes improvements to permissions, licensing, and installation:

Issues Resolved
---------------

-  "Download original document" is missing extension.
-  **predefinedSearch** terms don't appear in the viewer.
-  **pcc.config** requires OWAS account name and password, but are not used.
-  View/Preview fails without access to googleapis.com.
-  Install script exits with **Deployed = False** (when it's actually **True**).
-  Install script's "Enabling Feature" loops indefinitely when install fails.
-  Install script throws error if solution already exists.
-  Install "Repair" option doesn't restore missing files.

Features Added
--------------

-  Integrated PCC 10.4 SharePoint licensing.
-  Changed permissions model to allow assigning viewer permissions to SharePoint Permission Levels.
-  Provided customers a script to **Remove-PCCWOPIBinding**.
-  Updated documentation to include minor updates.

Upgrading from v2.0 to v2.1
---------------------------

Before installing PCC for SharePoint v2.1, complete the following steps to remove v2.0:

1.  Remove the PCC for SharePoint Solution (see instructions above).
2.  After removing the solution, remove Prizm Permission Levels: 
    -  Go to **Site settings** > **Site permissions**.
    -  Select **Permission Levels** on the ribbon.
    -  Check all **Prizm ...** permission levels and select **Delete Selected Permission Levels**.

Release Notes for v2.2
======================

PCC for SharePoint v2.2 addresses the following issues:

Issues Resolved
---------------

- Prizm Viewer Permissions displays "you do not have permission to access this feature" 
- Redact functionality available without permission being granted 

Features Added
--------------

- Added SSL support to installer and PowerShell scripts 
- Create Rendition 

Support
=======

Learn more about [Prizm Content Connect for SharePoint here](https://www.accusoft.com/products/prizm-content-connect-sharepoint/overview/).

If you have questions, please visit our online [help center](https://accusofthelp.zendesk.com/hc/en-us).	  	  	
