for x in {1..100};
   do (curl -s -w 'Total: %{time_total}s\n' "172.17.0.2:8080/up?project=../test/prj-1&data=../test/newt.csv&name=n_${x}&description=batchtest" &);
done