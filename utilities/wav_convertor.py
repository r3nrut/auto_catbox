from pydub import AudioSegment


    #song = AudioSegment.from_wav(filename)
    # need to get file name without extension
    # concatinate the file name with new extension
    # add album/artist info, use options for artist/album
    # use file name as the song title
songname = "11 Pilgrimage (Alternate Version)"
song = AudioSegment.from_wav("C:/somepath/"+songname+".wav")
song.export("C:/somepath/"+songname+".mp3",
            format="mp3",
            tags={"album": "The Fragile: Deviations", "artist": "Nine Inch Nails"})
    
