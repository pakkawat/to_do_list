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

---

ResourceGenerator.extract_file  
มีข้อจำกัดที่ว่า ถ้าแตกไฟล์ไปไว้ใน folder ที่มีไฟล์อื่นอยู่ด้วยจะทำให้ bash script ในขั้นตอนการแตกไฟล์ไม่ทำงานเพราะเงื่อนไข
only_if { Dir.entries('#{des_last_path}').size == 2 }
จะเป็น false เพราะใน folder มีไฟล์อื่นๆอยู่ด้วย

---

ResourceGenerator.copy_file
อาจจะต้องตัดทิ้งไปก่อนให้ไปใช้คำสั่ง execute_command แทน
เพราะ การ copy ไฟล์มีหลากหลายรูปแบบเช่น copy ไฟล์เดียว หรือ copy ทั้ง folder รวมไปถึงการ copy ไฟล์เดียวนั้น ไฟล์ที่ปลายทางอาจจะระบุชื่อ folder อย่างเดียวก็ได้ หรือ ระบุเป็นชื่อไฟล์ใหม่ก็ได้
