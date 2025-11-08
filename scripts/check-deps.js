#!/usr/bin/env node

/**
 * Dependency Checker
 * Verifies that optional external dependencies are installed
 */

const { execSync } = require('child_process');
const os = require('os');

const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  cyan: '\x1b[36m',
  gray: '\x1b[90m'
};

function checkCommand(cmd) {
  try {
    execSync(`${cmd} --version`, { stdio: 'pipe' });
    return true;
  } catch {
    return false;
  }
}

console.log(`\n${colors.cyan}Checking optional dependencies...${colors.reset}\n`);

let allGood = true;

// Check Babashka (required for modular workflow)
const hasBabashka = checkCommand('bb');
if (hasBabashka) {
  console.log(`${colors.green}✓${colors.reset} Babashka (bb) - installed`);
} else {
  console.log(`${colors.yellow}⚠${colors.reset} Babashka (bb) - not found`);
  console.log(`${colors.gray}  Required for: Modular template workflow (split/build)${colors.reset}`);
  console.log(`${colors.gray}  Install from: https://babashka.org/${colors.reset}`);

  const platform = os.platform();
  if (platform === 'darwin') {
    console.log(`${colors.gray}  Mac: brew install borkdude/brew/babashka${colors.reset}`);
  } else if (platform === 'win32') {
    console.log(`${colors.gray}  Windows: scoop install babashka${colors.reset}`);
  } else if (platform === 'linux') {
    console.log(`${colors.gray}  Linux: bash < <(curl -s https://raw.githubusercontent.com/babashka/babashka/master/install)${colors.reset}`);
  }
  console.log();
  allGood = false;
}

if (allGood) {
  console.log(`\n${colors.green}All optional dependencies are installed!${colors.reset}\n`);
} else {
  console.log(`${colors.yellow}Some optional dependencies are missing.${colors.reset}`);
  console.log(`${colors.gray}You can still use basic features, but modular workflow requires Babashka.${colors.reset}\n`);
}
