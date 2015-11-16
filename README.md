9.4.2 The destroy action (งง ลืม note ให้ดี)
---
ไปหน้า edit user แล้ว menu ข้างบนใช้ไม่ได้
---
Listing 11.1 แก้ index จาก ku_id เป็น ku_user_id

---
หน้า Edit Program (ex. /programs/36/edit)

Program Name เวลาเปลี่ยนต้องเข้าไปแก้ในไฟล์
"public/cookbooks/xampp/CHANGELOG.md", 
"public/cookbooks/xampp/recipes/default.rb", 
"public/cookbooks/xampp/metadata.rb", 
"public/cookbooks/xampp/README.md"
เป็นต้น ด้วยไหม เพราะถ้ามีตัวแปรชื่อเหมือนกับ Program Name จะโดนเปลี่ยนไปด้วย
---
ชื่อ Program ห้ามมี space
---
code ที่ยังไม่ได้เขียน find_all ด้วยคำว่า to_do

---
ต้องแก้พวกที่แสดง Error ให้แสดง Error ที่แท้จริง

เช่น systax ใน cookbook error เวลา upload cookbook จะไม่แสดง จะไปแสดงคำว่า "Error can not update cookbook"
---
ถ้าโปรแกรมอื่นภายในวิชาของนิสิตใช้ไฟล์ตัวเดียวกันในการติดตั้งห้ามลบโปรแกรมทิ้ง

code เริ่มต้น 
ChefAttribute.where("att_type = 'source' AND att_value LIKE (?)","%#{chef_resource.file_name}").count == 1
---
ทดสอบ delete program gเพราะเปลี่ยนขั้นตอนการลบโปรแกรมใหม่
