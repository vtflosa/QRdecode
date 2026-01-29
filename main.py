#!/usr/bin/python3
# coding: utf8

"""Decode qrcode from computer screen
Search the screen for multiple qrcode and decode them then launch firefox with decoded link
"""
import cv2
from mss import mss
import tkinter as tk
from tkinter import messagebox
import webbrowser
from urllib.parse import urlparse
import os


def is_valid_url(url):
    """Vérifie si le texte est une URL valide"""
    try:
        result = urlparse(url)
        # Vérifie qu'il y a au moins un schéma (http/https) et un netloc (domaine)
        return all([result.scheme in ['http', 'https', 'ftp'], result.netloc])
    except Exception:
        return False


def capture_screen():
    """Capture l'écran et retourne l'image"""
    try:
        with mss() as sct:
            screenshot = sct.shot(mon=-1, output='fullscreen.png')
        img = cv2.imread(screenshot)
        if img is None:
            raise ValueError("Impossible de lire la capture d'écran")
        return img, screenshot
    except Exception as e:
        raise RuntimeError(f"Erreur lors de la capture d'écran : {e}")


def detect_qrcodes(img):
    """Détecte et décode les QR codes dans l'image"""
    try:
        qcd = cv2.QRCodeDetector()
        retval, decoded_info, points, straight_qrcode = qcd.detectAndDecodeMulti(img)
        return retval, decoded_info
    except Exception as e:
        raise RuntimeError(f"Erreur lors de la détection des QR codes : {e}")


def main():
    screenshot_path = None
    try:
        # Capture d'écran
        img, screenshot_path = capture_screen()

        # Détection des QR codes
        retval, decoded_info = detect_qrcodes(img)

        print(f"QR code(s) trouvé(s) : {retval}")

        if retval:
            print(f"Informations décodées : {decoded_info}")
            urls = []
            non_urls = []

            for text_code in decoded_info:

                # Séparer URLs valides et autres contenus
                if is_valid_url(text_code):
                    answer = messagebox.askokcancel(
                        "Voulez-vous ouvrir le lien suivant ?",
                        f"{' ' * 300}Ouvrir : \n\n{text_code}\n{' ' * 300}",
                        parent=root,
                        icon=tk.messagebox.QUESTION
                    )
                    if answer:
                        urls.append(text_code)
                else:
                    non_urls.append(text_code)

            # Afficher les contenus non-URL détectés
            for text in non_urls:
                # Ignorer les QR codes vides
                if not text or text.strip() == "":
                    messagebox.showinfo(
                        "Contenu détecté mais vide",
                        f"{' ' * 300}\nUn QR code sans texte à été détecté\n\n",
                        parent=root)
                else:
                    messagebox.showinfo(
                        "Contenu non-URL détecté",
                        f"{' ' * 300}\nQR code détecté (URL non valide) :\n\n" +
                        f"{text}" +  # Limiter à 5 pour éviter une popup géante
                        f"\n{' ' * 300}",
                        parent=root)

            # Ouvrir les URLs validées
            for url in urls:
                try:
                    webbrowser.open_new_tab(url)
                except Exception as e:
                    messagebox.showerror(
                        "Erreur d'ouverture",
                        f"Impossible d'ouvrir {url}\n\nErreur : {e}",
                        parent=root
                    )

        else:
            messagebox.showinfo(
                "Pas de QR code !",
                f"{' ' * 300}\n"
                f"Je n'ai pas trouvé de QR code visible sur l'écran.\n"
                f"{' ' * 300}",
                parent=root
            )

    except RuntimeError as e:
        messagebox.showerror(
            "Erreur",
            f"{' ' * 300}\n{str(e)}\n{' ' * 300}",
            parent=root
        )
    except Exception as e:
        messagebox.showerror(
            "Erreur inattendue",
            f"{' ' * 300}\nUne erreur inattendue s'est produite :\n\n{str(e)}\n{' ' * 300}",
            parent=root
        )
    finally:
        # Nettoyage : supprimer le fichier screenshot
        if screenshot_path and os.path.exists(screenshot_path):
            try:
                os.remove(screenshot_path)
            except Exception:
                pass  # Ignorer les erreurs de suppression

        cv2.destroyAllWindows()


if __name__ == '__main__':
    root = tk.Tk()
    root.attributes('-alpha', 0.0)
    root.geometry("0x0+950+400")
    root.attributes('-topmost', False)
    root.overrideredirect(True)
    # root.withdraw()

    main()

