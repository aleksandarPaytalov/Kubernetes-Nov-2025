## Task1

- sed -e 's/%replicasCount%/3/' -e 's/%port%/80/' -e 's/%nodeport%/30001/' part1/1-manual/1-template.yaml (optional - to see changed manifest)
- sed -e 's/%replicasCount%/3/' -e 's/%port%/80/' -e 's/%nodeport%/30001/' part1/1-manual/1-template.yaml | kubectl apply -f -

## Task2

- mkdir base
- mkdir -pv overlays/{test,production}
- execute this command inside the task2 folder: kubectl apply -k overlays/test
- execute this command inside the task2 folder: kubectl apply -k overlays/production

## Task3

\*NOTE: Execute the commands from the task3\chart-hm folder

- helm install hm . --dry-run (optional)
- helm install hm .
