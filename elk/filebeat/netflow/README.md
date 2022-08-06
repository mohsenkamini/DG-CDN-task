&#x202b;

# مقدمه

دریافت اطلاعات مربوط به `netflow` و نمایش
این اطلاعات به نحو قابل استفاده برای شبکه های SDN 
و همچنین راه اندازی این سرویس در این داکیومنت ارایه شده است.

# چکیده

- [راه اندازی fprobe به عنوان netflow-exporter](#راه-اندازی-fprobe-به-عنوان-netflow-exporter)
- [پیکربندی filebeat به عنوان netflow-collector](#پیکربندی-filebeat-به-عنوان-netflow-collector)
- [اضافه نمودن داشبورد های مربوط به netflow به  kibana](#اضافه-نمودن-داشبورد-های-مربوط-به-netflow-به-kibana)

### راه اندازی fprobe به عنوان netflow-exporter

 راه اندازی این سرویس باید بر روی دستگاهی که قصد مانیتور کردن آن را داریم انجام شود.

**نصب fprobe :**

~~~
sudo apt update
sudo apt install fprobe
~~~

**پیکربندی :**

`vi /etc/default/fprobe`

~~~
#fprobe default configuration file

INTERFACE="ens160"
#### interfaces to be monitored
#### SET TO "any" for export all the interfaces data
FLOW_COLLECTOR="<filebeat agent address>:<port>"

#fprobe can't distinguish IP packet from other (e.g. ARP)
OTHER_ARGS="-fip"
~~~

و :

 `systemctl restart  fprobe.service`

### پیکربندی filebeat به عنوان netflow-collector

فایل بیت را میتوان هم به صورت containerized و هم به صورت سرویس systemctl بر روی host مربوطه مستقر نمود.
حتی به عنوان collector می تواند به صورت مرکزی قرار گیرد و از چند fprobe دیتا بگیرد.

اما در سناریو ونپاد از این رو که فایل بیت لاگ های دیگری همچپن syslog و iptables را پایش و ارسال می کند ترجیحا بر روی هر دستگاه یک سرویس filebeat قرار میگیرد.

پیکربندی  module netflow :

`vi data/filebeat/data01/filebeat.docker.yml`

~~~
  - module: netflow
    log:
      enabled: true
      var:
        netflow_host: 0.0.0.0
        netflow_port: 2055
~~~

 دایرکتیو های مربوط به host و port مشخصه ادرسی هستند که filebeat در آن  برای دریافت netflow logs,
 آماده Listen کردن خواهد بود .
    
همچنین در فایل `docker-compsoe.yml`
باید پورت مشخص شده در پیکربندی بالا که عموما ‍‍`2055` ‍‍می باشد
را به عنوان پورت های باز تعیین کنیم.

_داخلی و یا بر روی هاست باز کردن این پورت هنوز تست نشده است._


### اضافه نمودن داشبورد های مربوط به netflow به  kibana

با استفاده از api زیر می توان با ارایه authentication مناسب
داشبورد های جدید را به kibana  اضافه نمود.

`POST api/kibana/dashboards/import`

~~~
curl --location --request POST 'https://test.elk.ir/api/kibana/dashboards/import' \
--header 'kbn-xsrf: reporting' \
--header 'Authorization: Basic *********************' \
--header 'Content-Type: application/json' \
--data </PATH/TO/FILE>
~~~


لیست داشبورد های موجود در داشبورد های filebeat برای  netflow :

~~~
filebeat-netflow-traffic-analysis.json
filebeat-netflow-overview.json
filebeat-netflow-flow-exporters.json
filebeat-netflow-flow-records.json
filebeat-netflow-conversation-partners.json
filebeat-netflow-autonomous-systems.json
filebeat-netflow-top-n.json
filebeat-netflow-geo-location.json
filebeat-netflow-autonomous-systems.json
~~~
