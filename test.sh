ls ~/.dev-porta-process
cd test 
../bin/dev-porta >> log1 & 
echo $! >> pids
../bin/dev-porta >> log2 &
echo $! >> pids
../bin/dev-porta >> log3 &
echo $! >> pids
../bin/dev-porta >> log4 &
echo $! >> pids
cd ..
PORT=3000 ./bin/dev-porta
cat test/log*
rm test/pids test/log*
ls ~/.dev-porta-process