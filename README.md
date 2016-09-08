# API-VK-Friends

 ![Alt Text](https://github.com/5uper0/API-VK-Friends/blob/master/Screenshots/VK-API-Friends.gif)
 
 // Annotation


App made for fast access to list of users VK friends and is a part of homework from iOS Course Beginner. It has 4 levels of difficulty, uses VK API without OAuth, I made them and will introduce You to its features:


1. First screen shows list of user friends from VK using its API, friends images are used as detailed field.

2. By pressing on the friend cell, user will have new screen with friends info with big image and details. This made with (“users.get” request).

3. Added cell with subscriptions and followers buttons to quickly navigate to this lists of friend.

4. Added Wall button to new cell in friends info. By pressing it user will see friends wall on the new screen.


// Аннотация


Приложение реализовано как домашнее задание к уроку об API из iOS Course Beginner, состоит из 4 уровней сложности и использует VK API без OAuth. Я справился со всеми заданиями, и опишу что из этого вышло:

1. Приложение получает список друзей из ВК, в качестве дополнительного поля - только маленькую картинку.

2. По нажатию на ячейке друга,открывается новый экран, в котором находится детальное описание друга и большая картинка. Для этого используется метод "users.get".

3. В описании друга довалены две ячейки - subscriptions и followers. Если пользователь нажимает на них, то переходит в соответствующий контроллер. В одном случае отображается список подписок, а в другом список подписчиков.

4. В описание юзера добавлена еще одна ячейка - wall. По нажатию на нее происходит переход на стену пользователя.
