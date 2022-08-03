import os

# Enable stdout logging
enableStdOutLogging = os.environ['ENABLE_STDOUT_LOG']
logRotationBackupCount = os.environ['LOG_ROTATION_BACKUP_COUNT']

# Directory to store ledger.
LEDGER_DIR = os.environ['LEDGER_DIR']

# Directory to store logs.
LOG_DIR = os.environ['LOG_DIR']

#Directory to store keys.
KEYS_DIR = os.environ['KEYS_DIR']

# Directory to store genesis transactions files.
GENESIS_DIR = os.environ['GENESIS_DIR']

# Directory to store backups.
BACKUP_DIR = os.environ['BACKUP_DIR']

# Directory to store plugins.
PLUGINS_DIR = os.environ['PLUGINS_DIR']

# Directory to store node info.
NODE_INFO_DIR = os.environ['NODE_INFO_DIR']
NETWORK_NAME = os.environ['NETWORK_NAME']