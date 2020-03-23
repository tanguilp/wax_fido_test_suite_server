# WaxFidoTestSuiteServer

WIP

```
curl --header "Content-Type: application/json" --request POST --cookie "fido_test_suite=abcdef" --data '{"username":"johndoe@example.com","displayName":"John Doe","authenticatorSelection":{"residentKey":false,"authenticatorAttachment":"cross-platform","userVerification":"preferred"},"attestation":"direct"}' http://localhost:4000/attestation/options | jq
```

## Configuring the origin

### Setting `origin`

Don't forget to configure the origin. By default, in development environment, it is set to:

```elixir
config :wax, :origin, "http://localhost:4000"
```

### Starting the test server

```bash
iex -S mix phx.server
```

will launch the server in development mode (environment is not important for our purpose).

### Downloading the test suite

It is not publicly available. See
[https://fidoalliance.org/certification/functional-certification/conformance/](https://fidoalliance.org/certification/functional-certification/conformance/)
to be granted access.

### Testing

Launch the executable (beware, it is **NOT** signed - you better run it inside a VM).

On the main screen, click on "FIDO2 Tests".

Click on "DOWNLOAD SERVER METADATA" to load metadata. This is metadata used for testing and must
be loaded in Wax instead of the production metadata loaded from the FIDO2 Web Service. To do so:
- create the `/priv/fido2_metadata/` directory in this project
- unzip the metadata archive
- copy the JSON files into `/priv/fido2_metadata`
- configure metadata loading from directory, for instance in `conf/dev/exs`:

```elixir
config :wax, :metadata_dir, :wax_fido_test_suite_server
```

Then, select "Server tests" on the right menu and set the "Server URL" to
`http://localhost:4000`. Then click on "RUN".

## Testing from a Linux host

The test suite does not support Linux (support was silently dropped at some point).
One solution consists in installing a Windows VM and use the test suite from it:

### Download a Windows VM

[Windows 10 VM](https://developer.microsoft.com/en-us/windows/downloads/virtual-machines)
(licence lasts 90 days).

### Install the test suite

You might have to disable UAC to run the test suite. Once it's done, a binary
is installed in `C:\Program Files(x86)\FIDO Conformance Tools Installer` whose
name is `F`.

Double click to open it

### Configuring network

The VM should be configured to share IP addresses between VM and hosts OSes.
With VirtualBox, this is the "Bridged networking" option.

This is no sufficient to successfully run the test suite. Indeed, the origin is set by the
test suite in client data according to the value set in the "Server URL" field. This must
be, according to the FIDO2 specification, either an HTTPS URL or `localhost`. Configuring
SSL is possibly impossible, and the VM's localhost is always `127.0.0.1` whereas your test
server has another address, for example `192.168.100.97` (and Windows 10 cannot be tweaked
to
[change what localhost resolves to](https://medium.com/software-developer/change-what-localhost-resolves-to-in-windows-for-testing-ie-edge-on-parallels-or-virtualbox-vm-60a002849d94)).

It is however possible to redirect traffic with the following commands:

```powershell
netsh interface portproxy add v4tov4 listenaddress=127.0.0.1 listenport=4000 connectaddress=192.168.100.97 connectport=4000

netsh interface portproxy add v6tov4 listenaddress=::1 listenport=4000 connectaddress=192.168.100.97 connectport=4000
```
