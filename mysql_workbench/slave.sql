create database mydb1;
# 잘안되면 마스터 상태 다시 확인하고
# 슬래이브에서stop slave; 이거 먼저 실행해보고 아래 내용 변경하여 실행해본다

# 마스터 서버와 동기화
# 마스터서버의 퍼블릭 아이피 입력 (master_host)
# 접속정보 입력 (user, password)
# 마스터 로그 파일(master에서 가져옴 - File)
# 마스터 로그 포지션(master에서 가져옴 - position)
change master to master_host='3.36.123.224'
, master_user='root'
, master_password='bda'
, master_log_file='mysql-bin.000001'
, master_log_pos=599;

start slave;

show slave status;

# refresh해보면 마스터에서 작업한 데이터 들어와있음

