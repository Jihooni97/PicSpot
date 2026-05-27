//
//  ContentView.swift
//  PicSpot
//
//  Created by 서지훈 on 5/27/26.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = true
    @State private var isLoggedIn = false

    var body: some View {
        ZStack {
            if isLoading {
                SplashView()
                    .transition(.opacity)
            } else if !isLoggedIn {
                LoginView {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isLoggedIn = true
                    }
                }
                .transition(.opacity)
            } else {
                MainView()
                    .transition(.opacity)
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation(.easeInOut(duration: 0.4)) {
                isLoading = false
            }
        }
    }
}

struct LoginView: View {
    var onLogin: () -> Void

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [OceanTheme.foam, OceanTheme.skyBlue.opacity(0.5)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                VStack(spacing: 8) {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 56, weight: .light))
                        .foregroundStyle(OceanTheme.deepBlue)
                    Text("PicSpot")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(OceanTheme.deepBlue)
                    Text("로그인하고 시작하기")
                        .font(.subheadline)
                        .foregroundStyle(OceanTheme.oceanBlue)
                }

                VStack(spacing: 12) {
                    TextField("이메일", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(14)
                        .background(OceanTheme.foam)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(OceanTheme.skyBlue, lineWidth: 1)
                        )

                    SecureField("비밀번호", text: $password)
                        .textContentType(.password)
                        .padding(14)
                        .background(OceanTheme.foam)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(OceanTheme.skyBlue, lineWidth: 1)
                        )
                }
                .padding(.horizontal, 24)

                Button(action: onLogin) {
                    Text("로그인")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(OceanTheme.deepBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 24)

                HStack(spacing: 4) {
                    Text("아직 회원이 아니신가요?")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Button("회원가입") { }
                        .font(.footnote.bold())
                        .foregroundStyle(OceanTheme.deepBlue)
                }

                Spacer()

                HStack {
                    Rectangle()
                        .fill(OceanTheme.skyBlue)
                        .frame(height: 1)
                    Text("또는")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Rectangle()
                        .fill(OceanTheme.skyBlue)
                        .frame(height: 1)
                }
                .padding(.horizontal, 24)

                Button(action: onLogin) {
                    HStack {
                        Image(systemName: "apple.logo")
                        Text("Apple로 계속하기")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
}

struct SplashView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [OceanTheme.foam, OceanTheme.skyBlue.opacity(0.4)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 64, weight: .light))
                    .foregroundStyle(OceanTheme.deepBlue)
                Text("PicSpot")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(OceanTheme.deepBlue)
                Text("함께하는 우리")
                    .font(.title3)
                    .foregroundStyle(OceanTheme.oceanBlue)
            }
            .padding()
        }
    }
}

struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("홈", systemImage: "house.fill") }

            ShareView()
                .tabItem { Label("공유", systemImage: "square.grid.2x2.fill") }

            ProfileView()
                .tabItem { Label("내정보", systemImage: "person.circle.fill") }
        }
        .tint(OceanTheme.deepBlue)
    }
}

struct HomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            NoticeMarqueeView(text: "📢 PicSpot에 오신 것을 환영합니다! 사진을 업로드하면 위치 기반으로 주변 핫플레이스를 추천해드려요.")

            PhotoSliderView()
                .frame(height: 240)
                .padding(.top, 16)

            Spacer()
        }
        .background(OceanTheme.foam)
    }
}

struct ShareView: View {
    private let posts: [SharedPost] = [
        SharedPost(symbol: "beach.umbrella.fill", title: "협재 해수욕장", author: "수민", likes: 128),
        SharedPost(symbol: "sailboat.fill", title: "한강 요트", author: "지훈", likes: 92),
        SharedPost(symbol: "fish.fill", title: "수족관 데이트", author: "예린", likes: 64),
        SharedPost(symbol: "sun.max.fill", title: "강릉 일출", author: "민호", likes: 210),
        SharedPost(symbol: "drop.fill", title: "비 오는 부산", author: "하나", likes: 47),
        SharedPost(symbol: "cloud.sun.fill", title: "남해 드라이브", author: "재현", likes: 156)
    ]

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(posts) { post in
                        SharedPostCard(post: post)
                    }
                }
                .padding(16)
            }
            .background(OceanTheme.foam)
            .navigationTitle("함께 나눈 순간")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SharedPostCard: View {
    let post: SharedPost

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                LinearGradient(
                    colors: [OceanTheme.oceanBlue, OceanTheme.deepBlue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                Image(systemName: post.symbol)
                    .font(.system(size: 44, weight: .light))
                    .foregroundStyle(.white)
            }
            .aspectRatio(1, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 2) {
                Text(post.title)
                    .font(.subheadline.bold())
                    .foregroundStyle(OceanTheme.deepBlue)
                    .lineLimit(1)
                HStack(spacing: 6) {
                    Text("@\(post.author)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: "heart.fill")
                        .font(.caption2)
                        .foregroundStyle(OceanTheme.oceanBlue)
                    Text("\(post.likes)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

struct SharedPost: Identifiable {
    let id = UUID()
    let symbol: String
    let title: String
    let author: String
    let likes: Int
}

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(OceanTheme.oceanBlue)
                Text("내 프로필")
                    .font(.title2.bold())
                    .foregroundStyle(OceanTheme.deepBlue)
                Text("준비 중이에요")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding(.top, 60)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(OceanTheme.foam)
            .navigationTitle("내정보")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct NoticeMarqueeView: View {
    let text: String

    @State private var textWidth: CGFloat = 0
    @State private var offset: CGFloat = 0

    var body: some View {
        GeometryReader { proxy in
            let containerWidth = proxy.size.width

            Text(text)
                .font(.subheadline)
                .foregroundStyle(.white)
                .lineLimit(1)
                .fixedSize()
                .background(
                    GeometryReader { textProxy in
                        Color.clear
                            .onAppear {
                                textWidth = textProxy.size.width
                                startScrolling(containerWidth: containerWidth)
                            }
                    }
                )
                .offset(x: offset)
                .frame(width: containerWidth, alignment: .leading)
                .clipped()
        }
        .frame(height: 36)
        .background(OceanTheme.deepBlue)
    }

    private func startScrolling(containerWidth: CGFloat) {
        offset = containerWidth
        let totalDistance = containerWidth + textWidth
        let duration = Double(totalDistance) / 60.0
        withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
            offset = -textWidth
        }
    }
}

struct PhotoSliderView: View {
    private let slides: [SliderItem] = [
        SliderItem(symbol: "beach.umbrella.fill", title: "바다", colors: [OceanTheme.skyBlue, OceanTheme.oceanBlue]),
        SliderItem(symbol: "sailboat.fill", title: "요트", colors: [OceanTheme.oceanBlue, OceanTheme.deepBlue]),
        SliderItem(symbol: "sun.max.fill", title: "일출", colors: [OceanTheme.skyBlue, OceanTheme.deepBlue]),
        SliderItem(symbol: "fish.fill", title: "수족관", colors: [OceanTheme.oceanBlue, OceanTheme.skyBlue])
    ]

    @State private var currentIndex = 0

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(slides.enumerated()), id: \.offset) { index, item in
                SliderCard(item: item)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(3))
                withAnimation(.easeInOut) {
                    currentIndex = (currentIndex + 1) % slides.count
                }
            }
        }
    }
}

struct SliderCard: View {
    let item: SliderItem

    var body: some View {
        ZStack {
            LinearGradient(colors: item.colors, startPoint: .topLeading, endPoint: .bottomTrailing)

            VStack(spacing: 12) {
                Image(systemName: item.symbol)
                    .font(.system(size: 56, weight: .light))
                Text(item.title)
                    .font(.title2.bold())
            }
            .foregroundStyle(.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }
}

struct SliderItem {
    let symbol: String
    let title: String
    let colors: [Color]
}

enum OceanTheme {
    static let foam = Color.white
    static let skyBlue = Color(red: 168/255, green: 218/255, blue: 220/255)
    static let oceanBlue = Color(red: 0/255, green: 180/255, blue: 216/255)
    static let deepBlue = Color(red: 0/255, green: 119/255, blue: 182/255)
}

#Preview {
    ContentView()
}
