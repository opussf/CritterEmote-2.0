local _, CritterEmote = ...
function CritterEmote.GetCurrentActiveHolidays()
    CritterEmote.Log(CritterEmote.Debug, "Call to GetCurrentActiveHolidays()" )
    local now = C_DateAndTime.GetCurrentCalendarTime()
    local active = {}

    for monthOffset = -1, 3 do
        local monthInfo = C_Calendar.GetMonthInfo(monthOffset)
        local month = monthInfo.month
        local year = monthInfo.year

        for day = 1, monthInfo.numDays do
            local numEvents = C_Calendar.GetNumDayEvents(monthOffset, day)
            for eventIndex = 1, numEvents do
                local event = C_Calendar.GetDayEvent(monthOffset, day, eventIndex)
                if event.calendarType == "HOLIDAY" then
                    local start = event.startTime
                    local endt = event.endTime
                    -- print(monthOffset, day, event.title, event.calendarType, C_DateAndTime.CompareCalendarTime(now, start))

                    if C_DateAndTime.CompareCalendarTime(now, start) <= 0 and
                        C_DateAndTime.CompareCalendarTime(now, endt) >= 0 then
                            active[event.title] = true
                    end
                end
            end
        end
    end
    for event, _ in pairs(active) do
        CritterEmote.Log(CritterEmote.Debug, "Active Holiday: "..event)
    end
    return active
end
