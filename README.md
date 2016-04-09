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

---

ResourceGenerator.move_file
อาจจะต้องตัดทิ้งเหมือนกันให้ไปใช้ execute_command แทนเพราะ ไฟล์บางประเภทก็ไม่มีนามสกุลอาจจะทำให้เข้าใจผิดคิดว่าเป็น folder
แต่เอาจริงๆก็แค่เพิ่ม dropdown ว่าจะต้องการ move file หรือ folder แต่ก็ยังมาติดเรื่องของ destination_file ผู้ใช้งานอาจจะงงว่าต้องใส่แค่ path หรือ path + filename


---

ลบ ChefValue ออกเมื่อ Program ถูกลบ หรือ User ถอนออกจากวิชานั้นๆ เอาไว้เป็นงานในอนาคตไปก่อน เพราะมีปัญหาเรื่อง ถ้ามี Program ถูกใช้ทั้งในสองวิชาหรือมากกว่าแล้ว User ลงทะเบียนทั้งสองวิชานั้นๆหรือมากกว่าจะยังลบ ChefValue ไม่ได้ เพราะ Chef_resource has_many chef_attribute แล้ว chef_attribute ถึงจะ has_many chef_value

---

การลบ Chef_resource


---
การสร้าง chef_value จะเกิดเมื่อ
1. เมื่อความสัมพันระหว่าง user กับ subject (user_subject) ถูกสร้าง
2. เมื่อความสัมพันระหว่าง program กับ subject (programs_subject) ถูกสร้าง
3. เมื่อ chef_attribute ถูกสร้างที่หน้า edit chef_resource

การลบ chef_value จะเกิดเมื่อ

1. เมื่อความสัมพันธ์ระหว่าง program กับ chef_resource ( program_chef ) ถูกลบ ที่หน้า edit program
2. เมื่อความสัมพันธ์ระหว่าง user กับ subject (user_subkect ) ถูกลบ ที่หน้า user_subject
3. เมื่อ chef_attribute ถูกลบที่หน้า edit chef_resource (อันนี้ auto เพราะ chef_attribute has_many chef_value depedent destroy)

---

ถ้า user อยากเปลี่ยนค่า config ?

ตอบ ต้อง ลบ chef_resource ทิ้ง หรือ ลบ chef_attribute ออกแล้วสร้างใหม่

---

การลบไฟล์ใน template folder ของ function "Create_file" "Config_file" "Bash_script" จะเกิดก็ต่อเมื่อเกิดการ generate remove_disuse_resource 

---

จะทำความสัมพันของ UserProgram ให้เหมือนกับ UserPersonalProgram ไม่ได้ เพราะ Program สามารถอยู่ได้มากกว่าหนึ่ง Subject ดังนั้น ถ้า 2 Subject ใช้ Program ตัวเดียวกันและ user ลงทะเบียนเรียนทั้ง 2 Subject เวลาถอน Subject ออกไปแค่อันเดียวต้องยังไม่ลบ Program

---

เมื่อเกิดการ apply_change

ku_user_job ทำหน้าที่  generate_chef_resource_for_personal_program
( การ apply_change ของ ku_user_job จะเป็นของแต่ละ user ไม่ยุ่งเกี่ยวกันเพราะ user จะต้อง log in มากด apply_change เอง)

program_job ทำหน้าที่ generate_chef_resource(ของ program นั้น), clear_remove_disuse_resource, create_user_config_for_each_user

subject_job ทำหน้าที่ prepare_user_list ของแต่ละ program, create user_program กับ user_config
