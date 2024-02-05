INSTALL_DIR="$1"
# Install Terraform
wget -qO terraform.zip https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
unzip terraform.zip -d "${INSTALL_DIR}"

# # Install TfLint
# wget -qO tflint.zip https://github.com/terraform-linters/tflint/releases/download/v0.47.0/tflint_linux_amd64.zip
# unzip tflint.zip -d "${INSTALL_DIR}"
# mv "${INSTALL_DIR}/tflint" "${INSTALL_DIR}/tflint"
# chmod +x "${INSTALL_DIR}/tflint"
# # Check if 'tflint' is in the PATH
# if ! command -v tflint &> /dev/null; then
#     echo "tflint is not in the PATH. Adding it to PATH temporarily."
#     export PATH="${INSTALL_DIR}:${PATH}"
# fi

# # Verify that 'tflint' is now available
# tflint --version

# Install Tfsec
wget -qO tfsec https://github.com/aquasecurity/tfsec/releases/download/v1.28.1/tfsec-checkgen-linux-amd64
mv tfsec "${INSTALL_DIR}/tfsec"
chmod +x "${INSTALL_DIR}/tfsec"
