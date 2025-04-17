import React, { useState, useEffect, useRef } from "react"
import axios from "axios"

const FormUserSearch = ({ eventId, initialUsers = [], capacity }) => {
  const [query, setQuery] = useState("")
  const [suggestions, setSuggestions] = useState([])
  const [selectedUsers, setSelectedUsers] = useState(initialUsers)
  const [highlightIndex, setHighlightIndex] = useState(-1)
  const inputRef = useRef(null)

  useEffect(() => {
    if (query.length > 0) {
      axios.get(`/users/search?q=${query}`).then((res) => {
        setSuggestions(res.data)
        setHighlightIndex(0)
      })
    } else {
      setSuggestions([])
      setHighlightIndex(-1)
    }
  }, [query])

  const addUser = (user) => {
    if (!selectedUsers.some((u) => u.id === user.id)) {
      setSelectedUsers([...selectedUsers, user])
    }
    setQuery("")
    setSuggestions([])
    setHighlightIndex(-1)
    setTimeout(() => {
      inputRef.current?.focus()
    }, 0)
  }

  const removeUser = (id) => {
    setSelectedUsers(selectedUsers.filter((u) => u.id !== id))
  }

  const handleKeyDown = (e) => {
    if (e.key === "Enter" && e.nativeEvent.isComposing) return
    if (filteredSuggestions.length === 0) return

    if (e.key === "ArrowDown") {
      e.preventDefault()
      setHighlightIndex((prev) =>
        prev < filteredSuggestions.length - 1 ? prev + 1 : 0
      )
    } else if (e.key === "ArrowUp") {
      e.preventDefault()
      setHighlightIndex((prev) =>
        prev > 0 ? prev - 1 : filteredSuggestions.length - 1
      )
    } else if (e.key === "Enter") {
      e.preventDefault()
      const selected = filteredSuggestions[highlightIndex]
      if (selected) addUser(selected)
    }
  }

  const filteredSuggestions = suggestions.filter(
    (user) => !selectedUsers.some((u) => u.id === user.id)
  )

  // 🚨 上限チェックして submit ボタン制御
  useEffect(() => {
    const submitBtn = document.getElementById("submit-button")
    const warning = document.getElementById("submit-warning")
    const capacityInput = document.querySelector("[data-form-capacity-target='capacityInput']")
    const noLimitRadio = document.getElementById("event_no_limit")
  
    if (!submitBtn || !warning || !capacityInput || !noLimitRadio) return
  
    const updateButtonState = () => {
      const isNoLimit = noLimitRadio.checked
      const rawValue = capacityInput.value
      const parsedCapacity = isNoLimit ? Infinity : parseInt(rawValue, 10)
      const safeCapacity = isNaN(parsedCapacity) ? Infinity : parsedCapacity
  
      const isOver = selectedUsers.length + 1 > safeCapacity
      submitBtn.disabled = isOver
  
      if (isOver) {
        submitBtn.classList.remove("bg-orange-500", "hover:bg-orange-600")
        submitBtn.classList.add("bg-red-500", "cursor-not-allowed")
        warning.textContent = `参加者が上限（${isFinite(safeCapacity) ? safeCapacity : '制限なし'}人）を超えています`
        warning.classList.remove("hidden")
      } else {
        submitBtn.classList.remove("bg-red-500", "cursor-not-allowed")
        submitBtn.classList.add("bg-orange-500", "hover:bg-orange-600")
        warning.textContent = ""
        warning.classList.add("hidden")
      }
    }
  
    // 初期チェック
    updateButtonState()
  
    // イベント監視
    capacityInput.addEventListener("input", updateButtonState)
    noLimitRadio.addEventListener("change", updateButtonState)
  
    return () => {
      capacityInput.removeEventListener("input", updateButtonState)
      noLimitRadio.removeEventListener("change", updateButtonState)
    }
  }, [selectedUsers])

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <p className="text-sm text-gray-700 font-medium">参加する人は決まってる？</p>
        <p className="text-sm text-gray-500">自分もいれて、{selectedUsers.length+1}人が参加予定</p>
      </div>

      <div className="relative">
        <input
          ref={inputRef}
          type="text"
          placeholder="一緒に参加する人の名前を検索"
          className="w-full border rounded-lg p-3 text-sm"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          onKeyDown={handleKeyDown}
        />

        {query.length > 0 && filteredSuggestions.length === 0 && (
          <div className="absolute z-10 w-full mt-1 bg-white border rounded-lg shadow text-gray-500 text-sm px-4 py-2">
            ユーザーが見つかりません
          </div>
        )}

        {filteredSuggestions.length > 0 && (
          <ul className="absolute z-10 w-full mt-1 bg-white border rounded-lg shadow max-h-60 overflow-auto">
            {filteredSuggestions.map((user, index) => (
              <li
                key={user.id}
                onClick={() => addUser(user)}
                onMouseEnter={() => setHighlightIndex(index)}
                className={`flex items-center gap-3 px-4 py-2 cursor-pointer ${
                  highlightIndex === index ? "bg-blue-100" : ""
                }`}
              >
                <img
                  src={user.profile_picture || "/assets/default.png"}
                  alt=""
                  className="w-6 h-6 rounded-full border"
                  onError={(e) => {
                    e.target.onerror = null
                    e.target.src = "/assets/default.png"
                  }}
                />
                <span>{user.name}</span>
              </li>
            ))}
          </ul>
        )}
      </div>

      <div className="flex gap-2 overflow-x-auto pb-1">
        {selectedUsers.map((user) => (
          <div
            key={user.id}
            className="flex items-center gap-2 text-sm bg-blue-50 px-3 py-2 rounded-xl border shadow-sm flex-shrink-0"
          >
            <img
              src={user.profile_picture || "/assets/default.png"}
              className="w-8 h-8 rounded-full border"
              alt=""
              onError={(e) => {
                e.target.onerror = null
                e.target.src = "/assets/default.png"
              }}
            />
            <span>{user.name}</span>
            <button
              onClick={() => removeUser(user.id)}
              className="text-gray-400 hover:text-red-500"
              type="button"
            >
              ×
            </button>
            <input type="hidden" name="event[user_ids][]" value={user.id} />
          </div>
        ))}
      </div>
    </div>
  )
}

export default FormUserSearch