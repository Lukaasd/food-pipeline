import streamlit as st

from generation import answer_question
from retrieval import find_similar_reviews, load_reviews

st.set_page_config(page_title="Explorador de reseñas")
st.title("Explorador de reseñas")
st.caption("Buscá ejemplos en la muestra de reseñas indexadas.")

if "history" not in st.session_state:
    st.session_state.history = []


def show_answer(answer, matches):
    st.write(answer)

    if matches:
        with st.expander(f"Reseñas recuperadas ({len(matches)})"):
            for _, review in matches:
                city = review["city"] or "Sin ciudad"
                rating = review["rating"]
                stars = f"{rating:g} / 5" if rating is not None else "Sin puntuación"

                st.text(f'Reseña {review["review_id"]} · {city} · {stars}')
                st.text(review["comment"])


for exchange in st.session_state.history:
    with st.chat_message("user"):
        st.text(exchange["question"])

    with st.chat_message("assistant"):
        show_answer(exchange["answer"], exchange["matches"])


reviews = load_reviews()
cities = sorted({review["city"] for review in reviews if review["city"]})
ratings = sorted({
    review["rating"] for review in reviews if review["rating"] is not None
})

with st.sidebar:
    st.header("Filtros de búsqueda")
    selected_cities = st.multiselect("Ubicación", cities)
    selected_ratings = st.multiselect(
        "Puntuación",
        ratings,
        format_func=lambda rating: f"{rating:g} / 5",
    )
    st.caption("Dejá un filtro vacío para incluir todos sus valores.")


question = st.chat_input("¿Qué querés saber sobre las reseñas?")

if question and question.strip():
    question = question.strip()

    with st.chat_message("user"):
        st.text(question)

    with st.chat_message("assistant"):
        with st.spinner("Buscando reseñas y preparando la respuesta…"):
            matches = find_similar_reviews(question, selected_cities, selected_ratings)
            if matches:
                answer = answer_question(question, matches)
            else:
                answer = "No hay reseñas que coincidan con esos filtros en el índice."
        show_answer(answer, matches)

    st.session_state.history.append({
        "question": question,
        "answer": answer,
        "matches": matches,
    })