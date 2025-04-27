cargo build --release

# --format=both 
valgrind --tool=massif --pages-as-heap=yes --depth=50 --stacks=no --detailed-freq=100 --max-snapshots=1000 ./target/release/ai
