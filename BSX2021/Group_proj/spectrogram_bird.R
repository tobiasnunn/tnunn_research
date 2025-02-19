library(tuneR, warn.conflicts = F, quietly = T)

# I took a song from xeno canto that sounded close to what we want
# i couldnt figure out how to download the wikipedia one
# collected by: Lee Alder on the 13th of january in Cardiff

path <- "data/gtsong.wav"

song <- readWave(path, from = 0, to = 15, units = "seconds")


# extract signal[wtf?]

snd <- song@left

# duration
dur <- length(snd)/song@samp.rate

# samp rate
fs <- song@samp.rate
fs #hz
#48000

# demean to remove DC offset[ again wtf?]
snd <- snd - mean(snd)

#plot waveform
plot(snd, type = 'l', xlab = "Time (s/48,000)", ylab = "Frequency (Hz)")
# the time is in some weird unit, 15 seconds x the rate of 48000 is over 7000000
# which is 7x10^5 so idk what the units of this would be

