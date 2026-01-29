"""Decode qrcode from computer screen
Search the screen for multiple qrcode and decode them then launch firefox with decoded link
"""

import cv2
from mss import mss
import tkinter as tk
from tkinter import messagebox
import webbrowser


def main():
    with mss() as sct:
        screenshot = sct.shot(mon=-1, output='fullscreen.png')  # take full screenshot even with multiple monitors
    img = cv2.imread(screenshot)
    qcd = cv2.QRCodeDetector()
    retval, decoded_info, points, straight_qrcode = qcd.detectAndDecodeMulti(img)
    print(f"We found at least a qrcode int the image = {retval}")
    if retval:
        print(f"decoded infos are : {decoded_info}")
        urls = []

        for text_code in decoded_info:

            answer = messagebox.askokcancel("Voulez-vous ouvrir le liens suivant ?",
                                            f"{' ' * 300}Ouvrir : \n\n{text_code}\n{' ' * 300}", parent=root,
                                            icon=tk.messagebox.QUESTION)
            if answer:
                urls.append(text_code)

        for url in urls:
            webbrowser.open_new_tab(url)

    else:
        messagebox.showinfo("Pas de QRcode !", f"{' ' * 300}\n"
                                               f"Je n'ai pas trouvé de QRcode visible sur l'écran.\n"
                                               f"{' ' * 300}", parent=root)


if __name__ == '__main__':
    root = tk.Tk()
    root.geometry("1x1+950+400")
    # root.withdraw()
    main()

