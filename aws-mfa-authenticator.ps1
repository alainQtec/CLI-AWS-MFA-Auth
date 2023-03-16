# .SYNOPSIS
#    AWS MFA Authenticator class
# .DESCRIPTION
#    Handles the authentication for the CLI.
#    Requires:
#      aws-cli
# .EXAMPLE
#    $auth = [awsAuthenticator]::new()
#    $auth.login()
# .NOTES
#    Works On linux, Windows comming soon ...
class awsAuthenticator {
    [string]$COLOR_RED = $(tput setaf 1)
    [string]$COLOR_GREEN = $(tput setaf 2)
    [string]$COLOR_BLUE = $(tput setaf 4)
    [string]$COLOR_WHITE = $(tput setaf 7)
    [string]$COLOR_NORMAL = $(tput sgr0)
    [int]$COL_POS = 80
    [int]$IS_AWS_CLI_INSTALLED = 0
    [int]$IS_VERBOSE = 0
    # AWS vars
    [string]$AWS_DIRECTORY = "$env:USERPROFILE\.aws"
    [string]$AWS_SESSION_DATA = ""
    [string]$AWS_MFA_SERIAL_NUMBER_FILE = "$AWS_DIRECTORY\mfa_serial_number"
    [string]$AWS_MFA_SESSION_FILE = "$AWS_DIRECTORY\mfa_session"
    [string]$AWS_ACCOUNT_ID = ""
    [int]$AWS_TOKEN_TTL = 129600
    [int]$AWS_FORCE_TOKEN = 0
    [string]$AWS_PROFILE = "default"
    [string]$AWS_USERNAME = ""

    awsAuthenticator() {
        $this.AWS_MFA_SERIAL_NUMBER_FILE = [IO.PATH]::Combine($this.AWS_DIRECTORY, "mfa_serial_number")
        $this.AWS_MFA_SESSION_FILE = [IO.PATH]::Combine("$this.AWS_DIRECTORY", "mfa_session")
    }

    [void] login() {
        Clear-Host; $this.print_logo()
        # Get the user's access key ID and secret access key
        $accessKeyId = Read-Host "Please enter your AWS access key ID"
        $secretAccessKey = Read-Host "Please enter your AWS secret access key"

        # Set the AWS region
        $region = Read-Host "Please enter the AWS region you want to use (e.g. us-east-1)"
        # Set the output format for AWS CLI commands
        Set-AWSCredential -AccessKey $accessKeyId -SecretKey $secretAccessKey
        Set-DefaultAWSRegion -Region $region
        Set-AWSConfig -OutputFormat json

        # Test the AWS CLI configuration by getting a list of S3 buckets
        Write-Host ""
        Write-Host "Testing AWS CLI configuration by getting a list of S3 buckets..."
        Write-Host ""
        aws s3 ls

        # Provide a prompt to execute other AWS CLI commands
        Write-Host ""
        Write-Host "AWS CLI configuration completed successfully. You can now execute other AWS CLI commands."
        Write-Host ""

        # aws-authenticator -f -p MYAWSPROFILE
    }
    [void] get_input_data($message, [ref]$input) {
        while ([string]::IsNullOrEmpty($input.Value)) {
            Write-Host -NoNewline $this.COLOR_WHITE$message$this.COLOR_NORMAL
            $input.Value = Read-Host
        }
    }
    hidden [void] pause() {
        Write-Host -NoNewline "$($this.COLOR_WHITE)Press any key to continue...$($this.COLOR_NORMAL)"
        [void]$(Get-Variable host).value.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    [void] print_fail([string]$message) {
        $colPos = $this.COL_POS - $message.Length
        Write-Host -NoNewline "$message $($this.COLOR_RED) $('☠️' * $colPos) $($this.COLOR_NORMAL)"
    }

    [void] print_success([string]$message) {
        $colPos = $this.COL_POS - $message.Length
        Write-Host -NoNewline "$message $($this.COLOR_GREEN) $('👍🏼' * $colPos) $($this.COLOR_NORMAL)"
    }

    hidden [void] get_json_value($idx, [ref]$resultVar) {
        $jsonValue = [regex]::Match($this.AWS_SESSION_DATA, "$idx"": ""[^""]*").Value -replace "$idx"": """
        $resultVar.Value = $jsonValue
    }

    hidden [void] print_logo() {
        Write-Host ""
        Write-Host ""
        Write-Host " █████╗ ██╗    ██╗███████╗       ██████╗██╗     ██╗"
        Write-Host "██╔══██╗██║    ██║██╔════╝      ██╔════╝██║     ██║"
        Write-Host "███████║██║ █╗ ██║███████╗█████╗██║     ██║     ██║"
        Write-Host "██╔══██║██║███╗██║╚════██║╚════╝██║     ██║     ██║"
        Write-Host "██║  ██║╚███╔███╔╝███████║      ╚██████╗███████╗██║"
        Write-Host "╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝       ╚═════╝╚══════╝╚═╝"
        Write-Host "                                                   "
        Write-Host ""
        Write-Host "Amazon Web Services - CLI"
    }
}
