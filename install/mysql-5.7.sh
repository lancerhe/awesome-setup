#!/bin/sh
#
# description: install mysql
#
# author: Lancer He <lancer.he@gmail.com>
yum -y install make gcc-c++ cmake bison-devel ncurses-devel
cd /usr/local/src/
if [ ! -e mysql-5.7.17.tar.gz ]; then
    wget http://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.17.tar.gz
fi

groupadd mysql
useradd -g mysql mysql

if [ ! -f /data/mysql ]; then
    mkdir -p /data/mysql-5.7.17
    chown -R mysql:mysql /data/mysql-5.7.17
fi

tar zxvf mysql-5.7.17.tar.gz
cd mysql-5.7.17
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql-5.7.17 \
    -DMYSQL_UNIX_ADDR=/usr/local/mysql-5.7.17/var/mysql.sock \
    -DMYSQL_DATADIR=/data/mysql-5.7.17 \
    -DSYSCONFDIR=/usr/local/mysql-5.7.17/my.cnf \
    -DMYSQL_USER=mysql \
    -DMYSQL_TCP_PORT=3306 \
    -DEXTRA_CHARSETS=all \
    -DDEFAULT_CHARSET=utf8 \
    -DDEFAULT_COLLATION=utf8_general_ci \
    -DWITH_MYISAM_STORAGE_ENGINE=1 \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DWITH_ARCHIVE_STORAGE_ENGINE=1 \
    -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
    -DWITH_MEMORY_STORAGE_ENGINE=1 \
    -DWITH_PARTITION_STORAGE_ENGINE=1 \
    -DWITH_READLINE=1 \
    -DDOWNLOAD_BOOST=1 \
    -DWITH_BOOST=/usr/local/src \
    -DENABLED_LOCAL_INFILE=1

make -j 8
make install

mkdir /usr/local/mysql-5.7.17/var/
mkdir /usr/local/mysql-5.7.17/var/log/
touch /usr/local/mysql-5.7.17/var/log/error.log
mkdir /usr/local/mysql-5.7.17/var/run/
chown -R mysql:mysql /usr/local/mysql-5.7.17/var/
/usr/local/mysql-5.7.17/bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql-5.7.17 --datadir=/data/mysql-5.7.17 --user=mysql
rm -f /etc/my.cnf

cp support-files/mysql.server /etc/init.d/mysql.server
cp support-files/mysqld_multi.server /etc/init.d/mysqld_multi.server
chmod +x /etc/init.d/mysql.server
chmod +x /etc/init.d/mysqld_multi.server
echo '[client]
port    = 3306
socket  = /usr/local/mysql-5.7.17/var/mysql.sock

[mysql]
prompt="\u@DATABASE-MYSQL \R:\m:\s [\d]> "
no-auto-rehash

[mysqld]
user    = mysql
port    = 3306
basedir = /usr/local/mysql-5.7.17
datadir = /data/mysql-5.7.17/
socket  = /usr/local/mysql-5.7.17/var/mysql.sock
pid-file = DATABASE-MYSQL.pid
character-set-server = utf8mb4
skip_name_resolve = 1
open_files_limit    = 65535
back_log = 1024
max_connections = 512
max_connect_errors = 1000000
table_open_cache = 1024
table_definition_cache = 1024
table_open_cache_instances = 64
thread_stack = 512K
external-locking = FALSE
max_allowed_packet = 32M
sort_buffer_size = 16M
join_buffer_size = 16M
thread_cache_size = 768
query_cache_size = 0
query_cache_type = 0
interactive_timeout = 600
wait_timeout = 600
#default_table_type = DEFAULT_ENGINE
tmp_table_size = 96M
max_heap_table_size = 96M
slow_query_log = 1
slow_query_log_file = /usr/local/mysql-5.7.17/var/log/slow_query_log.log
log-error = /usr/local/mysql-5.7.17/var/log/error.log
long_query_time = 0.1
server-id = 3306
log-bin = /data/mysql-5.7.17/mybinlog
sync_binlog = 1
binlog_cache_size = 4M
max_binlog_cache_size = 2G
max_binlog_size = 1G
expire_logs_days = 7
master_info_repository = TABLE
relay_log_info_repository = TABLE
gtid_mode = on
enforce_gtid_consistency = 1
log_slave_updates
binlog_format = row
relay_log_recovery = 1
relay-log-purge = 1
key_buffer_size = 32M
read_buffer_size = 8M
read_rnd_buffer_size = 16M
bulk_insert_buffer_size = 64M
myisam_sort_buffer_size = 128M
myisam_max_sort_file_size = 10G
myisam_repair_threads = 1
lock_wait_timeout = 3600
explicit_defaults_for_timestamp = 1
innodb_thread_concurrency = 0
innodb_sync_spin_loops = 100
innodb_spin_wait_delay = 30

transaction_isolation = REPEATABLE-READ
#innodb_additional_mem_pool_size = 16M
innodb_buffer_pool_size = 8096M
innodb_buffer_pool_instances = 8
innodb_buffer_pool_load_at_startup = 1
innodb_buffer_pool_dump_at_shutdown = 1
innodb_data_file_path = ibdata1:10M:autoextend
innodb_flush_log_at_trx_commit = 2
innodb_log_buffer_size = 32M
innodb_log_file_size = 2G
innodb_log_files_in_group = 2
innodb_max_undo_log_size = 4G

# 根据您的服务器IOPS能力适当调整
# 一般配普通SSD盘的话，可以调整到 10000 - 20000
# 配置高端PCIe SSD卡的话，则可以调整的更高，比如 50000 - 80000
innodb_io_capacity = 4000
innodb_io_capacity_max = 8000

innodb_write_io_threads = 8
innodb_read_io_threads = 8
innodb_purge_threads = 4
innodb_page_cleaners = 4
innodb_open_files = 65535
innodb_max_dirty_pages_pct = 50
innodb_flush_method = O_DIRECT
innodb_lru_scan_depth = 4000
innodb_checksum_algorithm = crc32
#innodb_file_format = Barracuda
#innodb_file_format_max = Barracuda
innodb_lock_wait_timeout = 10
innodb_rollback_on_timeout = 1
innodb_print_all_deadlocks = 1
innodb_file_per_table = 1
innodb_online_alter_log_max_size = 4G
internal_tmp_disk_storage_engine = InnoDB
innodb_status_file = 1
innodb_status_output = 1
innodb_status_output_locks = 1
innodb_stats_on_metadata = 0

#performance_schema
performance_schema = 1
performance_schema_instrument = "%=on"

#innodb monitor
innodb_monitor_enable="module_innodb"
innodb_monitor_enable="module_server"
innodb_monitor_enable="module_dml"
innodb_monitor_enable="module_ddl"
innodb_monitor_enable="module_trx"
innodb_monitor_enable="module_os"
innodb_monitor_enable="module_purge"
innodb_monitor_enable="module_log"
innodb_monitor_enable="module_lock"
innodb_monitor_enable="module_buffer"
innodb_monitor_enable="module_index"
innodb_monitor_enable="module_ibuf_system"
innodb_monitor_enable="module_buffer_page"
innodb_monitor_enable="module_adaptive_hash"

[mysqldump]
quick
max_allowed_packet = 32M' > /usr/local/mysql-5.7.17/my.cnf

cd ..
rm -rf mysql-5.7.17

/etc/init.d/mysql.server start
netstat -an | grep LISTEN | grep 3306
chkconfig --add mysql.server

echo "export PATH=$PATH:/usr/local/mysql-5.7.17/bin/" >> /etc/profile
source /etc/profile

echo "Install mysql 5.7.17 successfully, setup mysql: 
/usr/local/mysql-5.7.17/bin/mysql -uroot -p'Your-Tmp-Password'
ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';"
