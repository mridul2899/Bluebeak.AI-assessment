for x in {1..100};
   do (curl -s -w 'Total: %{time_total}s\n' "localhost:8080/up?project=prj-1&data=newt.csv&name=n_${x}&description=batchtest" &);
done