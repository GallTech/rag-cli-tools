#!/bin/bash

batch1=(
  "https://outlook.live.com/mail/0/"
  "https://mail.google.com/"
)

batch2=(
  "https://modernpowershellautomation.github.io/reading/"
  "https://youtube.com"
  "https://news.ycombinator.com/"
  "https://newchristianbiblestudy.org/es/bible/latin-vulgata-clementina/genesis/"
)

batch3=(
"https://www.udemy.com/course/azure-ai-engineer-associate-ai-102-practice-tests-new/learn/quiz/6459963/results?expanded=1632287759#overview"
"https://www.coursera.org/learn/ai-102-microsoft-azure-ai-engineer-associate-course/lecture/CQkeB/azure-ai-foundry-demo"
"https://learn.microsoft.com/en-us/training/courses/ai-102t00"
"https://developers.google.com/machine-learning/crash-course/linear-regression"
)

open_urls() {
  for url in "$@"; do
    echo "Opening: $url"
    open -a "Floorp" "$url"
    sleep 0.5  # tiny delay to avoid macOS ignoring rapid opens
  done
}

for batch_name in batch1 batch2 batch3; do
  # Indirect array access for older Bash versions
  eval "urls=(\"\${${batch_name}[@]}\")"
  
  echo "Opening ${batch_name}..."
  open_urls "${urls[@]}"

  echo
  read -n 1 -s -r -p "✅ Finished this batch. Press any key to open the next batch..."
  echo
done

echo "✅ All batches opened!"