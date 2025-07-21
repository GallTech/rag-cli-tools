#!/bin/bash
# enhance_existing_repo.sh - Upgrade existing rag-cli-tools with docs/structure

# Safety check - ensure we're in the right directory
if [ ! -f "launch_labvms.sh" ]; then
  echo "❌ Error: Run this from your repo's root directory (where launch_labvms.sh lives)"
  exit 1
fi

# Configuration
AUTHOR="Your Name"
LICENSE="MIT"  # Change to "BSD-2-Clause" or other if needed
REPO_NAME="rag-cli-tools"

# Create directories (won't overwrite existing)
mkdir -p {bin,utils,examples,docs}

# Rehome existing scripts
if [ -f "launch_labvms.sh" ]; then
  mv launch_labvms.sh bin/
  chmod +x bin/launch_labvms.sh
fi

# Generate .gitignore (if doesn't exist)
if [ ! -f ".gitignore" ]; then
  cat > .gitignore << 'EOF'
# System files
.DS_Store
*.swp
*~

# Binaries/compiled files
/bin/
*.exe
*.pyc

# Secrets
.env
*.key
*.pem
EOF
fi

# Generate README.md (backup existing first)
if [ -f "README.md" ]; then
  mv README.md README.old.md
  echo "⚠️ Backed up existing README.md to README.old.md"
fi

cat > README.md << EOF
# $REPO_NAME

> CLI tools for managing RAG infrastructure and lab environments

## 🚀 Featured Tools
- \`bin/launch_labvms.sh\` - WezTerm tabbed SSH connector
$( [ -f "utils/"* ] && echo "- \`utils/\` - Helper scripts" )

## 📦 Installation
\`\`\`bash
git clone https://github.com/$(git config --get user.name)/$REPO_NAME.git
cd $REPO_NAME
chmod +x bin/*
\`\`\`

## 🛠️ Structure
\`\`\`
.
├── bin/           # Main executable scripts
├── utils/         # Support utilities
├── examples/      # Configuration templates
├── docs/          # Documentation
└── README.md      # You're here!
\`\`\`

## 📜 License
[$LICENSE License](LICENSE) © $AUTHOR
EOF

# Generate LICENSE (if missing)
if [ ! -f "LICENSE" ]; then
  case $LICENSE in
    MIT)
      curl -s https://opensource.org/licenses/MIT > LICENSE
      ;;
    BSD-2-Clause)
      curl -s https://opensource.org/licenses/BSD-2-Clause > LICENSE
      ;;
  esac
  echo "📜 Added $LICENSE license"
fi

# Initialize Git if not already
if [ ! -d ".git" ]; then
  git init
  git add .
  git commit -m "chore: Initialize repository structure"
  echo "✅ Git repository initialized"
else
  echo "ℹ️ Existing Git repository detected - no initialization needed"
fi

echo "
🎉 Repository enhanced with:
├── bin/            # Moved your scripts here
├── docs/           # For screenshots/guides
├── .gitignore      # Standard exclusions
├── LICENSE         # $LICENSE license
└── README.md       # Professional overview

Next steps:
1. Review the auto-generated README.md
2. Add other scripts to bin/ or utils/
3. Take a screenshot for docs/demo.gif
"