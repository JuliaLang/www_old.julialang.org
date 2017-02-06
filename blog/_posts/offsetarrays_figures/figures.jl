using TestImages, Images

img = testimage("mandrill")
imgeye = img[35:99,130:220]
imgnose = img[331:445,145:350]
save("mandrill.png", img)
save("mandrill_eye.png", imgeye)
save("mandrill_nose.png", imgnose)
