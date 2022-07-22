<#ftl output_format="HTML" />

<!DOCTYPE html>
<html>
<head>
    <title>Picker API Quickstart</title>
    <meta charset="utf-8"/>
</head>
<body>
<p>Picker API API Quickstart</p>

<!--Add buttons to initiate auth sequence and sign out-->
<button id="authorize_button" onclick="handleAuthClick()">Authorize</button>
<button id="signout_button" onclick="handleSignoutClick()">Sign Out</button>

<pre id="content" style="white-space: pre-wrap;"></pre>

<script type="text/javascript">
    /* exported gapiLoaded */
    /* exported gisLoaded */
    /* exported handleAuthClick */
    /* exported handleSignoutClick */

    // Authorization scopes required by the API; multiple scopes can be
    // included, separated by spaces.
    const SCOPES = 'https://www.googleapis.com/auth/drive.metadata.readonly';

    // TODO(developer): Set to client ID and API key from the Developer Console

    const CLIENT_ID = '373281915127-91ok3535vva75vl7493e4op9c2suatjl.apps.googleusercontent.com';
    const API_KEY = 'AIzaSyD5c8aEvv5k68uIf5z8iGkXOn3n4WJhU3A';
    // TODO(developer): Replace with your own project number from console.developers.google.com.
    const APP_ID = '373281915127';

    let tokenClient;
    let accessToken = null;
    let pickerInited = false;
    let gisInited = false;


    document.getElementById('authorize_button').style.visibility = 'hidden';
    document.getElementById('signout_button').style.visibility = 'hidden';

    /**
     * Callback after api.js is loaded.
     */
    function gapiLoaded() {
        gapi.load('picker', intializePicker);
    }

    /**
     * Callback after the API client is loaded. Loads the
     * discovery doc to initialize the API.
     */
    function intializePicker() {
        pickerInited = true;
        maybeEnableButtons();
    }

    /**
     * Callback after Google Identity Services are loaded.
     */
    function gisLoaded() {
        tokenClient = google.accounts.oauth2.initTokenClient({
            client_id: CLIENT_ID,
            scope: SCOPES,
            callback: '', // defined later
        });
        gisInited = true;
        maybeEnableButtons();
    }

    /**
     * Enables user interaction after all libraries are loaded.
     */
    function maybeEnableButtons() {
        if (pickerInited && gisInited) {
            document.getElementById('authorize_button').style.visibility = 'visible';
        }
    }

    /**
     *  Sign in the user upon button click.
     */
    function handleAuthClick() {
        tokenClient.callback = async (response) => {
            if (response.error !== undefined) {
                throw (response);
            }
            accessToken = response.access_token;
            document.getElementById('signout_button').style.visibility = 'visible';
            document.getElementById('authorize_button').innerText = 'Refresh';
            await createPicker();
        };

        if (accessToken === null) {
            // Prompt the user to select a Google Account and ask for consent to share their data
            // when establishing a new session.
            tokenClient.requestAccessToken({prompt: 'consent'});
        } else {
            // Skip display of account chooser and consent dialog for an existing session.
            tokenClient.requestAccessToken({prompt: ''});
        }
    }

    /**
     *  Sign out the user upon button click.
     */
    function handleSignoutClick() {
        if (accessToken) {
            accessToken = null;
            google.accounts.oauth2.revoke(accessToken);
            document.getElementById('content').innerText = '';
            document.getElementById('authorize_button').innerText = 'Authorize';
            document.getElementById('signout_button').style.visibility = 'hidden';
        }
    }

    /**
     *  Create and render a Picker object for searching images.
     */
    function createPicker() {
        const view = new google.picker.DocsView(google.picker.ViewId.DOCS);
        view.setMimeTypes('image/png,image/jpeg,image/jpg');
        const picker = new google.picker.PickerBuilder()
            .setLocale('zh-TW')
            .enableFeature(google.picker.Feature.NAV_HIDDEN)
            .enableFeature(google.picker.Feature.MULTISELECT_ENABLED)
            .setDeveloperKey(API_KEY)
            .setOAuthToken(accessToken)
            .addView(view)
            // .addView(new google.picker.DocsUploadView())
            .setCallback(pickerCallback)
            .build();
        picker.setVisible(true);
    }

    /**
     * Displays the file details of the user's selection.
     * @param {object} data - Containers the user selection from the picker
     */
    function pickerCallback(data) {
        if (data.action === google.picker.Action.PICKED) {
            document.getElementById('content').innerText = JSON.stringify(data, null, 2);
        }
    }
</script>
<script async defer src="https://apis.google.com/js/api.js" onload="gapiLoaded()"></script>
<script async defer src="https://accounts.google.com/gsi/client" onload="gisLoaded()"></script>
</body>
</html>